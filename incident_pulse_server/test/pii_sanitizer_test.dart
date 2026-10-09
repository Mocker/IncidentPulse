import 'package:test/test.dart';
import 'package:incident_pulse_server/src/services/pii_sanitizer.dart';

void main() {
  group('PiiSanitizer Compliance & Redaction Engine', () {
    test('Redacts bearer authorization headers and tokens', () {
      const input = 'Request Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xyz';
      final redacted = PiiSanitizer.redact(input);
      expect(redacted, contains('Bearer [REDACTED_TOKEN]'));
      expect(redacted, isNot(contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9')));
    });

    test('Redacts Stripe and webhook secrets (whsec_, sk_live_, sk_test_)', () {
      const input = 'Failed with key whsec_99182a7b8c9d and sk_live_51MabcXYZ987654321';
      final redacted = PiiSanitizer.redact(input);
      expect(redacted, equals('Failed with key [REDACTED_SECRET] and [REDACTED_SECRET]'));
      expect(redacted, isNot(contains('whsec_99182a7b8c9d')));
      expect(redacted, isNot(contains('sk_live_51MabcXYZ987654321')));
    });

    test('Redacts customer email addresses to prevent GDPR leak', () {
      const input = 'Customer alert for user john.doe+billing@acme-corp.com and ceo@enterprise.org';
      final redacted = PiiSanitizer.redact(input);
      expect(redacted, equals('Customer alert for user [REDACTED_EMAIL] and [REDACTED_EMAIL]'));
      expect(redacted, isNot(contains('john.doe+billing@acme-corp.com')));
      expect(redacted, isNot(contains('ceo@enterprise.org')));
    });

    test('Redacts credit card numbers (PCI-DSS compliance)', () {
      const input = 'Card charge failed for 4111 2222 3333 4444 on gateway';
      final redacted = PiiSanitizer.redact(input);
      expect(redacted, contains('[REDACTED_CARD]'));
      expect(redacted, isNot(contains('4111 2222 3333 4444')));
    });

    test('Preserves non-sensitive operational payloads untouched', () {
      const input = '{"status": 503, "endpoint": "/api/v1/health", "latencyMs": 450}';
      final redacted = PiiSanitizer.redact(input);
      expect(redacted, equals(input));
    });

    test('Handles empty strings safely', () {
      expect(PiiSanitizer.redact(''), equals(''));
    });
  });
}
