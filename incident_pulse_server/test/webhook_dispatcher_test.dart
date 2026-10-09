import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:incident_pulse_server/src/services/webhook_dispatcher.dart';

void main() {
  group('WebhookDispatcher & Outbound Adapters', () {
    test('Computes deterministic HMAC-SHA256 signature', () {
      const secret = 'whsec_testing_secret_key_123';
      const body = '{"event": "incident.triggered", "id": 42}';

      final signature = WebhookDispatcher.computeHmacSignature(secret, body);
      expect(signature, startsWith('sha256='));

      // Validate against independent HMAC computation
      final expectedHash = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(body));
      expect(signature, equals('sha256=$expectedHash'));
    });

    test('Transforms triggered incident into Discord rich embed with red color and alert emoji', () {
      final inputData = {
        'event': 'incident.triggered',
        'timestamp': '2026-10-09T00:00:00Z',
        'service': {'id': 1, 'name': 'Payment Gateway', 'slug': 'payment-gateway'},
        'incident': {
          'id': 105,
          'title': 'Stripe Webhook Delivery Failure',
          'description': 'HTTP 500 returned on charge.failed event',
          'severity': 'CRITICAL',
          'status': 'triggered',
        },
        'links': {
          'warRoomUrl': 'https://pulse.ryanguthrie.com/#/war-room/105',
        },
      };

      final discordPayload = WebhookDispatcher.buildDiscordPayload(inputData);
      expect(discordPayload['content'], contains('🚨'));
      expect(discordPayload['content'], contains('[CRITICAL] Payment Gateway'));

      final embeds = discordPayload['embeds'] as List;
      expect(embeds.length, equals(1));

      final embed = embeds.first as Map<String, dynamic>;
      expect(embed['color'], equals(0xEF4444)); // Red for critical/triggered
      expect(embed['title'], contains('Incident #105'));
      expect(embed['url'], equals('https://pulse.ryanguthrie.com/#/war-room/105'));

      final fields = embed['fields'] as List;
      final statusField = fields.firstWhere((f) => f['name'] == 'Status');
      expect(statusField['value'], equals('TRIGGERED'));
    });

    test('Transforms resolved incident into green embed with checkmark emoji', () {
      final inputData = {
        'event': 'incident.resolved',
        'timestamp': '2026-10-09T00:15:00Z',
        'service': {'id': 2, 'name': 'Auth Service', 'slug': 'auth-service'},
        'incident': {
          'id': 106,
          'title': 'OAuth token refresh delay',
          'description': 'Degradation resolved.',
          'severity': 'MEDIUM',
          'status': 'resolved',
          'rootCause': 'Database replica caught up after failover',
        },
        'links': {},
      };

      final discordPayload = WebhookDispatcher.buildDiscordPayload(inputData);
      expect(discordPayload['content'], contains('✅'));

      final embed = (discordPayload['embeds'] as List).first as Map<String, dynamic>;
      expect(embed['color'], equals(0x10B981)); // Green for resolved

      final fields = embed['fields'] as List;
      final rootCauseField = fields.firstWhere((f) => f['name'] == 'Root Cause');
      expect(rootCauseField['value'], contains('Database replica caught up'));
    });

    test('Transforms acknowledged incident into blue embed', () {
      final inputData = {
        'event': 'incident.acknowledged',
        'service': {'name': 'Workers API'},
        'incident': {
          'id': 107,
          'title': 'High CPU spike',
          'severity': 'HIGH',
          'status': 'acknowledged',
        },
      };

      final discordPayload = WebhookDispatcher.buildDiscordPayload(inputData);
      expect(discordPayload['content'], contains('👁️'));

      final embed = (discordPayload['embeds'] as List).first as Map<String, dynamic>;
      expect(embed['color'], equals(0x3B82F6)); // Blue for acknowledged
    });
  });
}
