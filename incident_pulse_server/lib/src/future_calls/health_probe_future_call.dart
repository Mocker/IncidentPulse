import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/scheduled_tasks.dart';

/// Periodic background worker that probes configured health endpoints
/// for registered services and records latency / downtime. Delegates to
/// [ScheduledTasks] so the Future Call path and the fallback sweep
/// endpoints share one implementation.
class HealthProbeFutureCall extends FutureCall {
  Future<void> probe(Session session, Service? service) async {
    if (service == null) return;
    await ScheduledTasks.probeService(session, service);
  }
}
