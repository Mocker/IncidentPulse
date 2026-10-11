import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/scheduled_tasks.dart';

/// Background task that checks if a triggered incident is still unacknowledged
/// after the escalation timeout window. Delegates to [ScheduledTasks] so the
/// Future Call path and the fallback sweep endpoints share one implementation.
class EscalationFutureCall extends FutureCall {
  Future<void> escalate(Session session, Incident? incident) async {
    if (incident == null) return;
    await ScheduledTasks.escalateIncident(session, incident);
  }
}
