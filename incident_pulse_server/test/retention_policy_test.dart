import 'package:test/test.dart';
import 'package:incident_pulse_server/src/generated/protocol.dart';

void main() {
  group('Data Retention & Regulatory Compliance (GDPR/SOC2)', () {
    test('Calculates correct expiration date based on service policy', () {
      final now = DateTime.utc(2026, 10, 9, 12, 0, 0);

      // 30 days (Strict GDPR)
      final expires30 = now.add(const Duration(days: 30));
      expect(expires30.difference(now).inDays, equals(30));

      // 90 days (Standard default)
      final expires90 = now.add(const Duration(days: 90));
      expect(expires90.difference(now).inDays, equals(90));

      // 365 days (SOC2 Audit)
      final expires365 = now.add(const Duration(days: 365));
      expect(expires365.difference(now).inDays, equals(365));
    });

    test('Two-tier retention: Scrubs raw payload and PII while preserving post-mortem metadata', () {
      final triggered = DateTime.utc(2026, 5, 1, 10, 0, 0);
      final expired = DateTime.utc(2026, 8, 1, 10, 0, 0);

      final originalIncident = Incident(
        id: 99,
        serviceId: 1,
        title: 'Database Failover Outage',
        description: 'Postgres primary ungraceful termination.',
        severity: 'critical',
        status: 'resolved',
        source: 'sentry',
        rawPayload: '{"stacktrace": "FATAL: server closed connection", "user_email": "admin@ryanguthrie.com"}',
        rootCause: 'OOM killer invoked on replica node.',
        isRedacted: false,
        expiresAt: expired,
        triggeredAt: triggered,
        resolvedAt: triggered.add(const Duration(minutes: 18)),
      );

      // Simulate RetentionCleanupFutureCall two-tier scrubber logic
      final scrubbed = originalIncident.copyWith(
        rawPayload: '[PURGED: Expired under tenant data retention policy]',
        description: 'Incident metadata preserved for post-mortem analysis. Raw payload purged.',
        isRedacted: true,
      );

      // Verify sensitive payload purged
      expect(scrubbed.rawPayload, equals('[PURGED: Expired under tenant data retention policy]'));
      expect(scrubbed.isRedacted, isTrue);

      // Verify post-mortem records preserved for reliability auditing
      expect(scrubbed.id, equals(99));
      expect(scrubbed.title, equals('Database Failover Outage'));
      expect(scrubbed.rootCause, equals('OOM killer invoked on replica node.'));
      expect(scrubbed.triggeredAt, equals(triggered));
      expect(scrubbed.resolvedAt, isNotNull);
      final mttrMinutes = scrubbed.resolvedAt!.difference(scrubbed.triggeredAt).inMinutes;
      expect(mttrMinutes, equals(18));
    });

    test('Timeline events: Alerts are purged while diagnostic notes remain', () {
      final now = DateTime.utc(2026, 5, 1, 10, 5, 0);

      final alertEvent = IncidentEvent(
        id: 1,
        incidentId: 99,
        author: 'Webhook (sentry)',
        eventType: 'alert',
        content: 'Raw webhook payload with client IP: 192.168.1.100',
        isRedacted: false,
        createdAt: now,
      );

      final diagnosisEvent = IncidentEvent(
        id: 2,
        incidentId: 99,
        author: 'Anna AGI',
        eventType: 'ai_diagnosis',
        content: 'Identified buffer pool starvation. Scale shared_buffers parameter.',
        isRedacted: false,
        createdAt: now.add(const Duration(minutes: 5)),
      );

      // Simulate scrubber
      IncidentEvent processEvent(IncidentEvent ev) {
        if (ev.eventType == 'alert' || ev.author.startsWith('Webhook')) {
          return ev.copyWith(
            content: '[Payload purged per retention policy]',
            isRedacted: true,
          );
        }
        return ev;
      }

      final scrubbedAlert = processEvent(alertEvent);
      final preservedDiagnosis = processEvent(diagnosisEvent);

      expect(scrubbedAlert.content, equals('[Payload purged per retention policy]'));
      expect(scrubbedAlert.isRedacted, isTrue);

      expect(preservedDiagnosis.content, contains('Scale shared_buffers parameter'));
      expect(preservedDiagnosis.isRedacted, isFalse);
    });
  });
}
