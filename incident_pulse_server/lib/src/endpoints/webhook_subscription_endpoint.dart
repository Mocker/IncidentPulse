import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class WebhookSubscriptionEndpoint extends Endpoint {
  /// Lists all active outbound webhook subscriptions, optionally filtered by service
  Future<List<WebhookSubscription>> listSubscriptions(
    Session session, {
    int? serviceId,
  }) async {
    if (serviceId != null) {
      return await WebhookSubscription.db.find(
        session,
        where: (t) => t.serviceId.equals(serviceId) | t.serviceId.equals(null),
        orderBy: (t) => t.createdAt.desc(),
      );
    }
    return await WebhookSubscription.db.find(
      session,
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  /// Registers a new generic outbound webhook subscription
  Future<WebhookSubscription> createSubscription(
    Session session, {
    required String name,
    required String targetUrl,
    int? serviceId,
    String? secretKey,
    Map<String, String>? customHeaders,
    List<String>? events,
  }) async {
    final subscription = WebhookSubscription(
      name: name,
      targetUrl: targetUrl,
      serviceId: serviceId,
      secretKey: secretKey,
      customHeaders: customHeaders,
      events: events ?? [
        'incident.triggered',
        'incident.acknowledged',
        'incident.escalated',
        'incident.resolved',
      ],
      isActive: true,
      createdAt: DateTime.now(),
    );

    return await WebhookSubscription.db.insertRow(session, subscription);
  }

  /// Deletes a webhook subscription
  Future<bool> deleteSubscription(
    Session session, {
    required int subscriptionId,
  }) async {
    final sub = await WebhookSubscription.db.findById(session, subscriptionId);
    if (sub == null) return false;

    await WebhookSubscription.db.deleteRow(session, sub);
    return true;
  }

  /// Sends a test ping to verify webhook target connectivity and HMAC verification
  Future<Map<String, dynamic>> testSubscription(
    Session session, {
    required int subscriptionId,
  }) async {
    final sub = await WebhookSubscription.db.findById(session, subscriptionId);
    if (sub == null) {
      return {'success': false, 'error': 'Subscription not found'};
    }

    try {
      final uri = Uri.parse(sub.targetUrl);
      final payload = {
        'event': 'incident.test_ping',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'subscription': {
          'id': sub.id,
          'name': sub.name,
        },
        'message': 'This is a test notification from IncidentPulse.',
      };

      final jsonBody = jsonEncode(payload);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'User-Agent': 'IncidentPulse-Webhook/1.0',
        if (sub.customHeaders != null) ...sub.customHeaders!,
      };

      if (sub.secretKey != null && sub.secretKey!.isNotEmpty) {
        final hmac = Hmac(sha256, utf8.encode(sub.secretKey!));
        final signature = hmac.convert(utf8.encode(jsonBody));
        headers['X-IncidentPulse-Signature'] = 'sha256=$signature';
      }

      final response = await http
          .post(uri, headers: headers, body: jsonBody)
          .timeout(const Duration(seconds: 5));

      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'statusCode': response.statusCode,
        'responseBody': response.body.length > 500 ? response.body.substring(0, 500) : response.body,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
