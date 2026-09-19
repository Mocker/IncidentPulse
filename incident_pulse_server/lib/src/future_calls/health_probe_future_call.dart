import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Periodic background worker that probes configured health endpoints
/// for registered services and records latency / downtime.
class HealthProbeFutureCall extends FutureCall {
  Future<void> probe(Session session, Service? service) async {
    if (service == null || service.id == null || service.pingUrl == null) return;

    final url = Uri.tryParse(service.pingUrl!);
    if (url == null) return;

    final now = DateTime.now();
    try {
      final headers = <String, String>{
        'User-Agent': 'IncidentPulse-UptimeProbe/1.0',
        if (service.pingHeaders != null) ...service.pingHeaders!,
      };

      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));

      // Detect if intercepted by Cloudflare Access login redirect or unauthorized
      final isCloudflareLogin = (response.isRedirect &&
              (response.headers['location']?.contains('cloudflareaccess.com') ?? false)) ||
          (response.request?.url.host.contains('cloudflareaccess.com') ?? false) ||
          (response.body.contains('cloudflareaccess.com') && response.body.contains('cdn-cgi/access'));

      final isOk = !isCloudflareLogin && response.statusCode >= 200 && response.statusCode < 400;
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
            description: 'HTTP ${response.statusCode} returned from probe URL ${service.pingUrl}',
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
            content: 'Synthetic uptime probe returned HTTP ${response.statusCode}',
            isRedacted: false,
            createdAt: now,
          );
          await IncidentEvent.db.insertRow(session, event);
          session.messages.postMessage('incident_${created.id}', event);
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
}
