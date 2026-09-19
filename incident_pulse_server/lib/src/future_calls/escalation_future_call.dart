import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/webhook_dispatcher.dart';

/// Background task that checks if a triggered incident is still unacknowledged
/// after the escalation timeout window. If still unacknowledged, escalates
/// to secondary channels (e.g. founder SMS/email or emergency webhook dispatch).
class EscalationFutureCall extends FutureCall {
  Future<void> escalate(Session session, Incident? incident) async {
    if (incident == null || incident.id == null) return;

    // Reload latest state of incident from DB
    final latest = await Incident.db.findById(session, incident.id!);
    if (latest == null) return;

    // If still triggered and unacknowledged, trigger escalation
    if (latest.status == 'triggered') {
      session.log(
        'ESCALATION TRIGGERED: Incident #${latest.id} ("${latest.title}") is still unacknowledged after timeout!',
        level: LogLevel.error,
      );

      final now = DateTime.now();
      final event = IncidentEvent(
        incidentId: latest.id!,
        author: 'Escalation Engine',
        eventType: 'alert',
        content: '⚠️ Escalation alert: Incident unacknowledged for > 5 minutes. Notifying secondary on-call and registered incident responders.',
        isRedacted: false,
        createdAt: now,
      );
      await IncidentEvent.db.insertRow(session, event);

      // Broadcast escalation into live war room
      session.messages.postMessage(
        'incident_${latest.id}',
        event,
      );

      // Look up escalation policy for service
      final policy = await EscalationPolicy.db.findFirstRow(
        session,
        where: (t) => t.serviceId.equals(latest.serviceId),
      );

      if (policy != null && policy.isActive) {
        session.log(
          'Dispatching escalation notification to email: ${policy.notifyEmail} / webhook: ${policy.notifyWebhookUrl}',
          level: LogLevel.info,
        );
      }

      // Dispatch generic outbound webhooks for incident.escalated
      final service = await Service.db.findById(session, latest.serviceId);
      if (service != null) {
        WebhookDispatcher.dispatch(
          session,
          event: 'incident.escalated',
          incident: latest,
          service: service,
        );
      }
    }
  }
}
