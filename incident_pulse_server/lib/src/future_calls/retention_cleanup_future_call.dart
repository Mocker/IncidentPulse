import 'package:serverpod/serverpod.dart';
import '../services/scheduled_tasks.dart';

/// Automated compliance worker that enforces tenant data retention windows
/// (GDPR, CCPA, SOC2). Delegates to [ScheduledTasks] so the Future Call
/// path and the fallback sweep endpoints share one implementation.
class RetentionCleanupFutureCall extends FutureCall {
  Future<void> cleanup(Session session) async {
    await ScheduledTasks.runRetentionCleanup(session);
  }
}
