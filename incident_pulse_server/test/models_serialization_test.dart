import 'dart:convert';
import 'package:test/test.dart';
import 'package:incident_pulse_server/src/generated/protocol.dart';

void main() {
  group('IncidentPulse Serverpod Models Serialization', () {
    test('Service model serializes and deserializes correctly', () {
      final now = DateTime.now();
      final service = Service(
        id: 1,
        name: 'Ryan Portfolio',
        slug: 'ryan-portfolio',
        webhookKey: 'whk_test_123',
        pingUrl: 'https://ryanguthrie.com',
        status: 'operational',
        checkIntervalSeconds: 60,
        isInternalOwner: true,
        enableAiBridge: true,
        dataRetentionDays: 365,
        redactPii: true,
        createdAt: now,
      );

      final jsonMap = service.toJson();
      expect(jsonMap['name'], equals('Ryan Portfolio'));
      expect(jsonMap['slug'], equals('ryan-portfolio'));
      expect(jsonMap['isInternalOwner'], isTrue);
      expect(jsonMap['enableAiBridge'], isTrue);
      expect(jsonMap['dataRetentionDays'], equals(365));
      expect(jsonMap['redactPii'], isTrue);

      final decoded = Service.fromJson(jsonMap);
      expect(decoded.name, equals(service.name));
      expect(decoded.slug, equals(service.slug));
      expect(decoded.webhookKey, equals(service.webhookKey));
    });

    test('Incident model serializes and enforces retention expiration', () {
      final now = DateTime.now();
      final expires = now.add(const Duration(days: 90));
      final incident = Incident(
        id: 42,
        serviceId: 1,
        title: 'High Latency on API',
        description: 'Response time exceeded 1000ms',
        severity: 'high',
        status: 'triggered',
        source: 'uptime',
        rawPayload: '{"latency": 1250}',
        isRedacted: false,
        expiresAt: expires,
        triggeredAt: now,
      );

      final jsonMap = incident.toJson();
      expect(jsonMap['severity'], equals('high'));
      expect(jsonMap['status'], equals('triggered'));
      expect(jsonMap['source'], equals('uptime'));

      final decoded = Incident.fromJson(jsonMap);
      expect(decoded.id, equals(42));
      expect(decoded.title, equals('High Latency on API'));
      expect(decoded.expiresAt!.isAfter(decoded.triggeredAt), isTrue);
    });

    test('IncidentEvent model supports war room chat and alert timeline', () {
      final now = DateTime.now();
      final event = IncidentEvent(
        id: 101,
        incidentId: 42,
        author: 'Anna AGI',
        eventType: 'ai_diagnosis',
        content: 'Root cause identified: Redis connection pool timeout.',
        isRedacted: false,
        createdAt: now,
      );

      final jsonMap = event.toJson();
      expect(jsonMap['author'], equals('Anna AGI'));
      expect(jsonMap['eventType'], equals('ai_diagnosis'));

      final decoded = IncidentEvent.fromJson(jsonMap);
      expect(decoded.incidentId, equals(42));
      expect(decoded.author, equals('Anna AGI'));
      expect(decoded.content, contains('Redis connection pool timeout'));
    });

    test('WebhookSubscription model serializes events list correctly', () {
      final now = DateTime.now();
      final sub = WebhookSubscription(
        id: 5,
        name: 'Discord Ops Alerts',
        targetUrl: 'https://discord.com/api/webhooks/123/xyz',
        serviceId: null,
        events: [
          'incident.triggered',
          'incident.acknowledged',
          'incident.resolved',
        ],
        secretKey: 'sec_test_hmac',
        isActive: true,
        createdAt: now,
      );

      final jsonMap = sub.toJson();
      expect(jsonMap['name'], equals('Discord Ops Alerts'));
      expect(jsonMap['events'], contains('incident.triggered'));
      expect(jsonMap['events'], contains('incident.resolved'));
      expect(jsonMap['isActive'], isTrue);

      final decoded = WebhookSubscription.fromJson(jsonMap);
      expect(decoded.targetUrl, equals(sub.targetUrl));
      expect(decoded.secretKey, equals('sec_test_hmac'));
      expect(decoded.events.length, equals(3));
    });

    test('ReliabilityReport model stores aggregated MTTR and uptime metrics', () {
      final now = DateTime.now();
      final report = ReliabilityReport(
        id: 7,
        serviceId: 1,
        uptimePercent: 99.98,
        incidentCount: 2,
        mttrMinutes: 4.5,
        healthScore: 98.2,
        reportSummary: 'Optimal SLA compliance. 2 minor degradations resolved autonomously.',
        generatedAt: now,
      );

      final jsonMap = report.toJson();
      expect(jsonMap['uptimePercent'], equals(99.98));
      expect(jsonMap['mttrMinutes'], equals(4.5));
      expect(jsonMap['healthScore'], equals(98.2));

      final decoded = ReliabilityReport.fromJson(jsonMap);
      expect(decoded.serviceId, equals(1));
      expect(decoded.incidentCount, equals(2));
    });
  });
}
