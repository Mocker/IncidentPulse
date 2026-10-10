import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'webhook_dispatcher.dart';

/// Shared, idempotent implementations of IncidentPulse's scheduled work.
///
/// These functions are the single code path behind BOTH scheduling modes:
/// 1. **Future Calls** (idiomatic Serverpod): `EscalationFutureCall`,
///    `HealthProbeFutureCall`, `RetentionCleanupFutureCall` delegate here.
/// 2. **Fallback sweeps** (for runtimes where future-call execution is
///    unavailable, e.g. Serverpod Cloud trial): the `runDueEscalations`,
///    `runHealthProbes`, `runRetentionCleanup` endpoints call the same
///    functions. Triggered by an external cron and/or lazily on reads.
///
/// Idempotency contract: running the same sweep twice (or a future call
/// racing a sweep) never double-escalates, double-probes harmfully, or
/// double-scrubs. Escalation is keyed on "no prior Escalation Engine event
/// exists for this incident"; probes are naturally idempotent (they just
/// record the latest status); cleanup only touches not-yet-redacted rows.
class ScheduledTasks {
  /// Escalates a single incident if it is still unacknowledged.
  /// Returns true if an escalation was performed.
  static Future<bool> escalateIncident(
    Session session,
    Incident incident,
  ) async {
    if (incident.id == null) return false;

    // Reload latest state — the incident may have been acknowledged
    // since it was scheduled/queued.
    final latest = await Incident.db.findById(session, incident.id!);
    if (latest == null || latest.status != 'triggered') return false;

    // Idempotency: never escalate the same incident twice.
    final alreadyEscalated = await IncidentEvent.db.findFirstRow(
      session,
      where: (t) =>
          t.incidentId.equals(latest.id!) &
          t.author.equals('Escalation Engine'),
    );
    if (alreadyEscalated != null) return false;

    session.log(
      'ESCALATION TRIGGERED: Incident #${latest.id} ("${latest.title}") is still unacknowledged after timeout!',
      level: LogLevel.error,
    );

    final now = DateTime.now();
    final event = IncidentEvent(
      incidentId: latest.id!,
      author: 'Escalation Engine',
      eventType: 'alert',
      content:
          '⚠️ Escalation alert: Incident unacknowledged for > 5 minutes. Notifying secondary on-call and registered incident responders.',
      isRedacted: false,
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    // Broadcast escalation into live war room
    session.messages.postMessage(
      'incident_${latest.id}',
      event,
    );

    // Look up escalation policy for service
    final policy = await EscalationPolicy.db.findFirstRow(
      session,
      where: (t) => t.serviceId.equals(latest.serviceId),
    );

    if (policy != null && policy.isActive) {
      session.log(
        'Dispatching escalation notification to email: ${policy.notifyEmail} / webhook: ${policy.notifyWebhookUrl}',
        level: LogLevel.info,
      );
    }

    // Dispatch generic outbound webhooks for incident.escalated
    final service = await Service.db.findById(session, latest.serviceId);
    if (service != null) {
      await WebhookDispatcher.dispatch(
        session,
        event: 'incident.escalated',
        incident: latest,
        service: service,
      );
    }

    return true;
  }

  /// Sweeps for incidents that have been unacknowledged past [overdueAfter]
  /// and escalates each. Returns the number of incidents escalated.
  static Future<int> runDueEscalations(
    Session session, {
    Duration overdueAfter = const Duration(minutes: 5),
  }) async {
    final cutoff = DateTime.now().subtract(overdueAfter);
    final overdue = await Incident.db.find(
      session,
      where: (t) =>
          t.status.equals('triggered') & (t.triggeredAt <= cutoff),
    );

    int escalated = 0;
    for (final incident in overdue) {
      if (await escalateIncident(session, incident)) escalated++;
    }
    if (escalated > 0) {
      session.log(
        'Due-escalation sweep: escalated $escalated incident(s).',
        level: LogLevel.info,
      );
    }
    return escalated;
  }

  /// Probes a single service's health endpoint and records the result,
  /// auto-creating an incident on 5xx responses.
  static Future<void> probeService(
    Session session,
    Service service,
  ) async {
    if (service.id == null || service.pingUrl == null) return;

    final url = Uri.tryParse(service.pingUrl!);
    if (url == null) return;

    final now = DateTime.now();
    try {
      final headers = <String, String>{
        'User-Agent': 'IncidentPulse-UptimeProbe/1.0',
        if (service.pingHeaders != null) ...service.pingHeaders!,
      };

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      // Detect if intercepted by Cloudflare Access login redirect or unauthorized
      final isCloudflareLogin = (response.isRedirect &&
              (response.headers['location']
                      ?.contains('cloudflareaccess.com') ??
                  false)) ||
          (response.request?.url.host.contains('cloudflareaccess.com') ??
              false) ||
          (response.body.contains('cloudflareaccess.com') &&
              response.body.contains('cdn-cgi/access'));

      final isOk =
          !isCloudflareLogin && response.statusCode >= 200 && response.statusCode < 400;
      final updated = service.copyWith(
        lastPingAt: now,
        lastPingStatus: isCloudflareLogin ? 401 : response.statusCode,
        status: isOk ? 'operational' : 'degraded',
      );
      await Service.db.updateRow(session, updated);

      if (!isOk) {
        session.log(
          'Health probe failed for ${service.name}: HTTP ${response.statusCode}',
          level: LogLevel.warning,
        );

        // Auto-create incident if server returns 5xx error
        if (response.statusCode >= 500) {
          final incident = Incident(
            serviceId: service.id!,
            title: 'Health Probe 5xx Error on ${service.name}',
            description:
                'HTTP ${response.statusCode} returned from probe URL ${service.pingUrl}',
            severity: 'high',
            status: 'triggered',
            source: 'uptime',
            isRedacted: false,
            triggeredAt: now,
          );
          final created = await Incident.db.insertRow(session, incident);

          final event = IncidentEvent(
            incidentId: created.id!,
            author: 'Synthetic Health Probe',
            eventType: 'alert',
            content:
                'Synthetic uptime probe returned HTTP ${response.statusCode}',
            isRedacted: false,
            createdAt: now,
          );
          await IncidentEvent.db.insertRow(session, event);
          session.messages.postMessage('incident_${created.id}', event);

          // Dispatch generic outbound webhooks
          await WebhookDispatcher.dispatch(
            session,
            event: 'incident.triggered',
            incident: created,
            service: service,
          );
        }
      }
    } catch (e) {
      session.log(
        'Health probe exception for ${service.name}: $e',
        level: LogLevel.error,
      );

      final updated = service.copyWith(
        lastPingAt: now,
        lastPingStatus: 0,
        status: 'down',
      );
      await Service.db.updateRow(session, updated);
    }
  }

  /// Probes every service with a configured ping URL. Returns the number
  /// of services probed.
  static Future<int> runHealthProbes(Session session) async {
    final services = await Service.db.find(session);
    int probed = 0;
    for (final service in services) {
      if (service.pingUrl == null || service.pingUrl!.isEmpty) continue;
      await probeService(session, service);
      probed++;
    }
    return probed;
  }

  /// Scrubs expired raw payloads per tenant retention windows. Returns the
  /// number of incidents sanitized.
  static Future<int> runRetentionCleanup(Session session) async {
    final now = DateTime.now();
    session.log('Running automated data retention and compliance cleanup...',
        level: LogLevel.info);

    // Find incidents past their retention expiration date that haven't been redacted yet
    final expiredIncidents = await Incident.db.find(
      session,
      where: (t) => (t.expiresAt <= now) & t.isRedacted.equals(false),
      limit: 500,
    );

    int sanitizedCount = 0;
    for (final inc in expiredIncidents) {
      // Scrub raw payload and mark incident as redacted
      final sanitized = inc.copyWith(
        rawPayload: '[PURGED: Expired under tenant data retention policy]',
        description:
            'Incident metadata preserved for post-mortem analysis. Raw payload purged.',
        isRedacted: true,
      );
      await Incident.db.updateRow(session, sanitized);

      // Scrub timeline event details for this incident
      final events = await IncidentEvent.db.find(
        session,
        where: (t) =>
            t.incidentId.equals(inc.id!) & t.isRedacted.equals(false),
      );

      for (final event in events) {
        if (event.eventType == 'alert' ||
            event.author.startsWith('Webhook')) {
          final scrubbedEvent = event.copyWith(
            content: '[Payload purged per retention policy]',
            isRedacted: true,
          );
          await IncidentEvent.db.updateRow(session, scrubbedEvent);
        }
      }

      sanitizedCount++;
    }

    session.log(
      'Data retention cleanup complete: Sanitized $sanitizedCount expired incidents.',
      level: LogLevel.info,
    );
    return sanitizedCount;
  }
}
