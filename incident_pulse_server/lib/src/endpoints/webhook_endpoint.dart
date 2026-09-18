import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class WebhookEndpoint extends Endpoint {
  /// Public webhook ingress endpoint.
  /// Authenticates using the service's webhookKey, applies PII redaction,
  /// sets compliance data retention expiration, and creates an incident.
  Future<bool> ingestWebhook(
    Session session, {
    required String webhookKey,
    required String source,
    required String rawPayloadJson,
  }) async {
    // 1. Authenticate service by webhookKey
    final service = await Service.db.findFirstRow(
      session,
      where: (t) => t.webhookKey.equals(webhookKey),
    );

    if (service == null) {
      session.log('Webhook rejected: Invalid webhookKey', level: LogLevel.warning);
      return false;
    }

    // 2. Sanitize and redact PII if enabled on service
    String processedPayload = rawPayloadJson;
    if (service.redactPii) {
      processedPayload = _redactSensitiveData(rawPayloadJson);
    }

    // 3. Parse payload based on source
    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(processedPayload);
    } catch (_) {
      data = {'raw': processedPayload};
    }

    String title = 'Alert from $source on ${service.name}';
    String description = 'Processed payload: $processedPayload';
    String severity = 'medium';

    if (source.toLowerCase() == 'sentry') {
      title = 'Sentry Issue: ${data['project_name'] ?? service.name} - ${data['message'] ?? 'Unhandled Exception'}';
      severity = (data['level'] == 'fatal' || data['level'] == 'error') ? 'high' : 'medium';
      description = 'Culprit: ${data['culprit'] ?? 'unknown'}\nURL: ${data['url'] ?? ''}';
    } else if (source.toLowerCase() == 'stripe') {
      final eventType = data['type'] ?? 'stripe_event';
      title = 'Stripe Failure: $eventType on ${service.name}';
      severity = eventType.toString().contains('payment_intent.payment_failed') ? 'critical' : 'high';
      description = 'Stripe event details: ${jsonEncode(data['data'] ?? {})}';
    } else if (source.toLowerCase() == 'uptime') {
      title = 'Downtime Alert: ${service.name} is DOWN';
      severity = 'critical';
      description = 'Health probe check failed. Response code: ${data['statusCode'] ?? 'timeout'}';
    }

    // 4. Calculate GDPR/compliance retention expiration
    final now = DateTime.now();
    final retentionDays = service.dataRetentionDays > 0 ? service.dataRetentionDays : 90;
    final expiresAt = now.add(Duration(days: retentionDays));

    // 5. Create incident and record in war room
    final incident = Incident(
      serviceId: service.id!,
      title: title,
      description: description,
      severity: severity,
      status: 'triggered',
      source: source.toLowerCase(),
      rawPayload: processedPayload,
      isRedacted: service.redactPii,
      expiresAt: expiresAt,
      triggeredAt: now,
    );

    final created = await Incident.db.insertRow(session, incident);

    // Update service status
    final updatedService = service.copyWith(
      status: severity == 'critical' ? 'down' : 'degraded',
    );
    await Service.db.updateRow(session, updatedService);

    // Add initial event to timeline
    final event = IncidentEvent(
      incidentId: created.id!,
      author: 'Webhook ($source)',
      eventType: 'alert',
      content: description,
      isRedacted: service.redactPii,
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    // Broadcast live event to War Room
    session.messages.postMessage(
      'incident_${created.id}',
      event,
    );

    // Schedule escalation check via FutureCall
    await session.serverpod.futureCallWithDelay(
      'EscalationFutureCall',
      created,
      const Duration(minutes: 5),
    );

    // Only dispatch to AI telemetry bridge if this is an internal project or customer explicitly opted-in
    if (service.isInternalOwner || service.enableAiBridge) {
      session.log(
        'Dispatching event #${created.id} to AI Telemetry Bridge (opt-in enabled).',
        level: LogLevel.info,
      );
    } else {
      session.log(
        'Tenant data isolation active: Skipping AI telemetry bridge dispatch for customer service #${service.id}.',
        level: LogLevel.info,
      );
    }

    return true;
  }

  /// Scrubs authorization headers, bearer tokens, credit cards, and emails
  String _redactSensitiveData(String input) {
    String text = input;

    // Redact Authorization headers / bearer tokens
    text = text.replaceAll(
      RegExp(r'(?i)(bearer\s+[a-z0-9_\-\.]+)', caseSensitive: false),
      'Bearer [REDACTED_TOKEN]',
    );

    // Redact API keys / secrets (whsec_, sk_live_, etc.)
    text = text.replaceAll(
      RegExp(r'(whsec_[a-zA-Z0-9]+|sk_live_[a-zA-Z0-9]+|sk_test_[a-zA-Z0-9]+)'),
      '[REDACTED_SECRET]',
    );

    // Redact email addresses
    text = text.replaceAll(
      RegExp(r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+'),
      '[REDACTED_EMAIL]',
    );

    // Redact 16-digit credit card patterns
    text = text.replaceAll(
      RegExp(r'\b(?:\d[ -]*?){13,16}\b'),
      '[REDACTED_CARD]',
    );

    return text;
  }
}
