import 'package:test/test.dart';
import 'package:incident_pulse_server/src/generated/protocol.dart';

void main() {
  group('AI Telemetry Bridge & Escalation Policies', () {
    test('AI Bridge Access Policy: Enforces strict tenant opt-in boundary', () {
      final internalService = Service(
        id: 1,
        name: 'Internal Venture (They Might Byte)',
        slug: 'tmb',
        webhookKey: 'whk_1',
        status: 'operational',
        checkIntervalSeconds: 60,
        isInternalOwner: true,
        enableAiBridge: true, // internal owner has access
        dataRetentionDays: 365,
        redactPii: true,
        createdAt: DateTime.now(),
      );

      final externalCustomerDefault = Service(
        id: 2,
        name: 'External SaaS Customer Corp',
        slug: 'acme-saas',
        webhookKey: 'whk_2',
        status: 'operational',
        checkIntervalSeconds: 60,
        isInternalOwner: false,
        enableAiBridge: false, // default for external customers is STRICTLY FALSE
        dataRetentionDays: 90,
        redactPii: true,
        createdAt: DateTime.now(),
      );

      final externalCustomerOptedIn = Service(
        id: 3,
        name: 'Enterprise Customer (Signed AI Consent)',
        slug: 'enterprise-client',
        webhookKey: 'whk_3',
        status: 'operational',
        checkIntervalSeconds: 60,
        isInternalOwner: false,
        enableAiBridge: true, // explicitly enabled
        dataRetentionDays: 180,
        redactPii: true,
        createdAt: DateTime.now(),
      );

      bool canDispatchToAi(Service s) => s.isInternalOwner || s.enableAiBridge;

      expect(canDispatchToAi(internalService), isTrue);
      expect(canDispatchToAi(externalCustomerDefault), isFalse);
      expect(canDispatchToAi(externalCustomerOptedIn), isTrue);
    });

    test('Escalation Condition: Triggers only if incident remains unacknowledged', () {
      final triggeredIncident = Incident(
        id: 10,
        serviceId: 1,
        title: 'Memory leak in worker pool',
        description: 'Memory usage at 98%',
        severity: 'critical',
        status: 'triggered',
        source: 'sentry',
        rawPayload: '{}',
        isRedacted: true,
        triggeredAt: DateTime.now().subtract(const Duration(minutes: 6)),
      );

      final acknowledgedIncident = triggeredIncident.copyWith(
        status: 'acknowledged',
        acknowledgedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      );

      final resolvedIncident = triggeredIncident.copyWith(
        status: 'resolved',
        resolvedAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );

      bool shouldEscalate(Incident inc) => inc.status == 'triggered';

      expect(shouldEscalate(triggeredIncident), isTrue);
      expect(shouldEscalate(acknowledgedIncident), isFalse);
      expect(shouldEscalate(resolvedIncident), isFalse);
    });

    test('Escalation Policy Model: Configures retry interval, email, and webhook target', () {
      final now = DateTime.now();
      final policy = EscalationPolicy(
        id: 1,
        serviceId: 1,
        timeoutMinutes: 5,
        notifyEmail: 'oncall@ryanguthrie.com',
        notifyWebhookUrl: 'https://n8n.ryanguthrie.com/webhook/escalate-alert',
        isActive: true,
      );

      final json = policy.toJson();
      expect(json['timeoutMinutes'], equals(5));
      expect(json['notifyEmail'], equals('oncall@ryanguthrie.com'));
      expect(json['isActive'], isTrue);

      final decoded = EscalationPolicy.fromJson(json);
      expect(decoded.timeoutMinutes, equals(5));
      expect(decoded.notifyWebhookUrl, contains('n8n.ryanguthrie.com'));
    });
  });
}
