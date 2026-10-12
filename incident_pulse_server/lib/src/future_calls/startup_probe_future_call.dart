import 'package:serverpod/serverpod.dart';
import '../endpoints/health_endpoint.dart';

/// One-shot probe scheduled at server startup to verify FutureCall execution.
/// Scheduling only proves the FutureCall API accepts the call; this probe
/// proves the executor actually runs it. When it fires, it flips
/// [ServerHealth.futureCallsExecuting], which [HealthEndpoint.heartbeat]
/// exposes — giving operators a definitive execution signal without log access.
class StartupProbeFutureCall extends FutureCall {
  Future<void> markExecuting(Session session) async {
    ServerHealth.futureCallsExecuting = true;
  }
}
