import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service that dispatches standard outbound webhooks for incident lifecycle events.
/// Decoupled from specific vendor platforms (Slack, Discord, PagerDuty, Zapier, n8n, etc.)
class WebhookDispatcher {
  /// Asynchronously dispatches an incident lifecycle event to all matching active WebhookSubscriptions
  static Future<void> dispatch(
    Session session, {
    required String event,
    required Incident incident,
    required Service service,
    String? warRoomUrl,
    String? acknowledgeUrl,
  }) async {
    try {
      // Find subscriptions for this specific service OR global subscriptions (serviceId == null)
      final subscriptions = await WebhookSubscription.db.find(
        session,
        where: (t) =>
            t.isActive.equals(true) &
            (t.serviceId.equals(service.id) | t.serviceId.equals(null)),
      );

      // Filter subscriptions that are subscribed to this event
      final targets = subscriptions.where((s) => s.events.contains(event)).toList();
      if (targets.isEmpty) return;

      final now = DateTime.now().toUtc().toIso8601String();
      final payload = {
        'event': event,
        'timestamp': now,
        'service': {
          'id': service.id,
          'name': service.name,
          'slug': service.slug,
        },
        'incident': {
          'id': incident.id,
          'title': incident.title,
          'description': incident.description,
          'severity': incident.severity,
          'status': incident.status,
          'source': incident.source,
          'rootCause': incident.rootCause,
          'triggeredAt': incident.triggeredAt.toIso8601String(),
          'acknowledgedAt': incident.acknowledgedAt?.toIso8601String(),
          'resolvedAt': incident.resolvedAt?.toIso8601String(),
        },
        'links': {
          'warRoomUrl': warRoomUrl ?? 'https://pulse.ryanguthrie.com/#/war-room/${incident.id}',
          'acknowledgeUrl': acknowledgeUrl ?? 'https://api.pulse.ryanguthrie.com/v1/incidents/${incident.id}/ack',
        },
      };

      final jsonString = jsonEncode(payload);

      for (final sub in targets) {
        // Asynchronously send to target without blocking caller
        _sendToSubscriber(session, sub, jsonString);
      }
    } catch (e, stack) {
      session.log('WebhookDispatcher error: $e\n$stack', level: LogLevel.error);
    }
  }

  static Future<void> _sendToSubscriber(
    Session session,
    WebhookSubscription sub,
    String jsonBody,
  ) async {
    try {
      final uri = Uri.tryParse(sub.targetUrl);
      if (uri == null) {
        session.log('Invalid webhook target URL: ${sub.targetUrl}', level: LogLevel.warning);
        return;
      }

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'User-Agent': 'IncidentPulse-Webhook/1.0',
        if (sub.customHeaders != null) ...sub.customHeaders!,
      };

      String bodyToSend = jsonBody;

      // Native adapter for Discord incoming webhooks
      if (uri.host.contains('discord.com')) {
        final dynamic data = jsonDecode(jsonBody);
        final ev = data['event'] as String? ?? 'incident.event';
        final inc = data['incident'] as Map<String, dynamic>? ?? {};
        final srv = data['service'] as Map<String, dynamic>? ?? {};
        final links = data['links'] as Map<String, dynamic>? ?? {};

        final title = inc['title'] as String? ?? 'Incident Notification';
        final severity = (inc['severity'] as String? ?? 'INFO').toUpperCase();
        final status = inc['status'] as String? ?? 'triggered';
        final srvName = srv['name'] as String? ?? 'Service';
        final warRoom = links['warRoomUrl'] as String? ?? '';

        int embedColor = 0xF59E0B; // Amber
        String emoji = '⚠️';
        if (severity == 'CRITICAL' || severity == 'HIGH' || status == 'triggered') {
          embedColor = 0xEF4444; // Red
          emoji = '🚨';
        }
        if (status == 'acknowledged') {
          embedColor = 0x3B82F6; // Blue
          emoji = '👁️';
        } else if (status == 'resolved') {
          embedColor = 0x10B981; // Green
          emoji = '✅';
        } else if (status == 'escalated') {
          embedColor = 0xDC2626; // Deep Crimson
          emoji = '🔥';
        }

        final discordPayload = {
          'content': '$emoji **[$severity] $srvName** — $title',
          'embeds': [
            {
              'title': '$emoji Incident #${inc['id']}: $title',
              'description': inc['description'] as String? ?? 'No description provided.',
              'color': embedColor,
              'fields': [
                {'name': 'Service', 'value': srvName, 'inline': true},
                {'name': 'Status', 'value': status.toUpperCase(), 'inline': true},
                {'name': 'Severity', 'value': severity, 'inline': true},
                if (inc['rootCause'] != null && inc['rootCause'].toString().isNotEmpty)
                  {'name': 'Root Cause', 'value': inc['rootCause'].toString(), 'inline': false},
              ],
              if (warRoom.isNotEmpty) 'url': warRoom,
              'footer': {
                'text': 'IncidentPulse • $ev • ${data['timestamp']}',
              },
            }
          ],
        };
        bodyToSend = jsonEncode(discordPayload);
      }

      // Compute HMAC-SHA256 signature if a secret key is configured
      if (sub.secretKey != null && sub.secretKey!.isNotEmpty) {
        final hmac = Hmac(sha256, utf8.encode(sub.secretKey!));
        final signature = hmac.convert(utf8.encode(bodyToSend));
        headers['X-IncidentPulse-Signature'] = 'sha256=$signature';
      }

      final response = await http
          .post(uri, headers: headers, body: bodyToSend)
          .timeout(const Duration(seconds: 5));

      session.log(
        'Dispatched webhook to "${sub.name}" (${sub.targetUrl}): HTTP ${response.statusCode}',
        level: response.statusCode >= 200 && response.statusCode < 300
            ? LogLevel.info
            : LogLevel.warning,
      );
    } catch (e) {
      session.log(
        'Failed to dispatch webhook to "${sub.name}" (${sub.targetUrl}): $e',
        level: LogLevel.error,
      );
    }
  }
}
