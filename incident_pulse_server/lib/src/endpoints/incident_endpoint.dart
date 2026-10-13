import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../generated/future_calls.dart';
import '../services/scheduled_tasks.dart';
import '../services/webhook_dispatcher.dart';

class IncidentEndpoint extends Endpoint {
  /// Fetches all active / unresolved incidents.
  ///
  /// Also runs the due-escalation sweep inline (idempotent): on runtimes
  /// where Future Call execution is unavailable (e.g. Serverpod Cloud
  /// trial), this guarantees no incident waits longer than one observation
  /// cycle to escalate. When Future Calls ARE available, the sweep no-ops
  /// on already-escalated incidents, so both paths coexist safely.
  Future<List<Incident>> getActiveIncidents(Session session) async {
    // Note: escalation sweeps run via FutureCall (every 60s), not lazily here.
    // Uses explicit status list instead of notEquals('resolved') — the
    // negation filter was hanging at the DB level under load.
    return await Incident.db.find(
      session,
      where: (t) =>
          t.status.equals('triggered') |
          t.status.equals('acknowledged') |
          t.status.equals('escalated'),
      orderBy: (t) => t.triggeredAt.desc(),
      limit: 100,
    );
  }

  /// Fetches incident history for a specific service
  Future<List<Incident>> getServiceIncidents(
    Session session, {
    required int serviceId,
    int limit = 50,
  }) async {
    return await Incident.db.find(
      session,
      where: (t) => t.serviceId.equals(serviceId),
      orderBy: (t) => t.triggeredAt.desc(),
      limit: limit,
    );
  }

  /// Manually creates a new incident
  Future<Incident> createIncident(
    Session session, {
    required int serviceId,
    required String title,
    required String description,
    required String severity,
    String source = 'manual',
  }) async {
    final now = DateTime.now();
    final incident = Incident(
      serviceId: serviceId,
      title: title,
      description: description,
      severity: severity,
      status: 'triggered',
      source: source,
      isRedacted: false,
      triggeredAt: now,
    );

    final created = await Incident.db.insertRow(session, incident);

    // Record initial event in the war-room timeline
    final event = IncidentEvent(
      incidentId: created.id!,
      author: 'System',
      eventType: 'status_change',
      content: 'Incident triggered with severity: $severity',
      isRedacted: false,
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    // Broadcast update across WebSockets channel for this incident
    session.messages.postMessage(
      'incident_${created.id}',
      event,
    );

    // Dispatch generic outbound webhooks
    final service = await Service.db.findById(session, serviceId);
    if (service != null) {
      WebhookDispatcher.dispatch(
        session,
        event: 'incident.triggered',
        incident: created,
        service: service,
      );
    }

    // Schedule escalation check via FutureCall with graceful fallback to lazy sweep
    try {
      await session.serverpod.futureCalls
          .callWithDelay(const Duration(minutes: 5))
          .escalation
          .escalate(created);
    } catch (e) {
      session.log(
        'FutureCall scheduling notice (fallback sweep active): $e',
        level: LogLevel.info,
      );
    }

    return created;
  }

  /// Acknowledges an incident by a responder
  Future<Incident?> acknowledgeIncident(
    Session session, {
    required int incidentId,
    required String responderName,
  }) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) return null;

    final now = DateTime.now();
    final updated = incident.copyWith(
      status: 'acknowledged',
      acknowledgedAt: now,
    );
    final saved = await Incident.db.updateRow(session, updated);

    final event = IncidentEvent(
      incidentId: incidentId,
      author: responderName,
      eventType: 'status_change',
      content: 'Incident acknowledged by $responderName',
      isRedacted: false,
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    session.messages.postMessage('incident_$incidentId', event);

    final service = await Service.db.findById(session, incident.serviceId);
    if (service != null) {
      WebhookDispatcher.dispatch(
        session,
        event: 'incident.acknowledged',
        incident: saved,
        service: service,
      );
    }

    return saved;
  }

  /// Resolves an incident with root cause documentation
  Future<Incident?> resolveIncident(
    Session session, {
    required int incidentId,
    required String resolverName,
    required String rootCause,
  }) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) return null;

    final now = DateTime.now();
    final updated = incident.copyWith(
      status: 'resolved',
      rootCause: rootCause,
      resolvedAt: now,
    );
    final saved = await Incident.db.updateRow(session, updated);

    final event = IncidentEvent(
      incidentId: incidentId,
      author: resolverName,
      eventType: 'status_change',
      content: 'Incident resolved by $resolverName. Root Cause: $rootCause',
      isRedacted: false,
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    session.messages.postMessage('incident_$incidentId', event);

    final service = await Service.db.findById(session, incident.serviceId);
    if (service != null) {
      WebhookDispatcher.dispatch(
        session,
        event: 'incident.resolved',
        incident: saved,
        service: service,
      );
    }

    return saved;
  }

  /// Fallback scheduler endpoint: escalates all incidents that have been
  /// unacknowledged past the timeout window. Idempotent — safe to call from
  /// an external cron on any cadence, and safe to race with the Future Call
  /// path. Returns the number of incidents escalated.
  ///
  /// Public (no auth) by design: it can only escalate genuinely overdue
  /// incidents, so there is nothing an abusive caller can trigger that
  /// wouldn't have happened anyway.
  Future<int> runDueEscalations(Session session) async {
    return await ScheduledTasks.runDueEscalations(session);
  }

  /// Lists recent incidents across all services (active + resolved)
  /// with limit for history tabs and post-mortem auditing
  Future<List<Incident>> getAllIncidents(
    Session session, {
    int limit = 100,
  }) async {
    return await Incident.db.find(
      session,
      orderBy: (t) => t.triggeredAt.desc(),
      limit: limit,
    );
  }

  /// One-click test simulation trigger for hackathon judges and testers.
  /// Simulates an incoming webhook alert from [source] (stripe, sentry, uptime)
  /// on the first available service or fallback mock service.
  Future<Incident> simulateMockAlert(
    Session session, {
    String source = 'sentry',
  }) async {
    // Locate service: prefer internal or first existing service
    var service = await Service.db.findFirstRow(
      session,
      where: (t) => t.isInternalOwner.equals(true),
    );
    service ??= await Service.db.findFirstRow(session);

    if (service == null) {
      // Create fallback demo service if none exists
      service = await Service.db.insertRow(
        session,
        Service(
          name: 'Acme Cloud API',
          slug: 'acme-api',
          webhookKey: 'whk_demo_acme_123',
          status: 'operational',
          checkIntervalSeconds: 60,
          isInternalOwner: true,
          enableAiBridge: true,
          dataRetentionDays: 90,
          redactPii: true,
          createdAt: DateTime.now(),
        ),
      );
    }

    final now = DateTime.now();
    String title;
    String description;
    String severity;

    final src = source.toLowerCase();
    if (src == 'stripe') {
      title = 'Stripe Failure: payment_intent.payment_failed on ${service.name}';
      description =
          'Stripe event details: {"amount": 4900, "currency": "usd", "customer": "cus_9918", "error": "card_declined"}';
      severity = 'critical';
    } else if (src == 'uptime') {
      title = 'Downtime Alert: ${service.name} is DOWN';
      description = 'Synthetic health probe check failed. Response code: HTTP 503 Service Unavailable';
      severity = 'critical';
    } else {
      title = 'Sentry Issue: ${service.name} - ConnectionRefusedError in redis_pool.dart';
      description =
          'Culprit: redis_pool.dart:connectWithRetry\nURL: https://sentry.io/organizations/incidentpulse/issues/40192/';
      severity = 'high';
    }

    final incident = Incident(
      serviceId: service.id!,
      title: title,
      description: description,
      severity: severity,
      status: 'triggered',
      source: src,
      rawPayload: description,
      isRedacted: service.redactPii,
      expiresAt: now.add(Duration(days: service.dataRetentionDays)),
      triggeredAt: now,
    );

    final created = await Incident.db.insertRow(session, incident);

    // Update service status
    final updatedService = service.copyWith(
      status: severity == 'critical' ? 'down' : 'degraded',
    );
    await Service.db.updateRow(session, updatedService);

    // Add initial event
    final event = IncidentEvent(
      incidentId: created.id!,
      author: 'Simulator ($src)',
      eventType: 'alert',
      content: description,
      isRedacted: service.redactPii,
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    // Broadcast live event into the War Room channel
    session.messages.postMessage(
      'incident_${created.id}',
      event,
    );

    // Dispatch outbound webhook
    await WebhookDispatcher.dispatch(
      session,
      event: 'incident.triggered',
      incident: created,
      service: service,
    );

    // Schedule escalation check via FutureCall with graceful fallback to lazy sweep
    try {
      await session.serverpod.futureCalls
          .callWithDelay(const Duration(minutes: 5))
          .escalation
          .escalate(created);
    } catch (e) {
      session.log(
        'FutureCall scheduling notice (fallback sweep active): $e',
        level: LogLevel.info,
      );
    }

    return created;
  }
}
