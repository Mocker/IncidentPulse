import 'package:serverpod/serverpod.dart';
import 'src/future_calls/escalation_future_call.dart';
import 'src/future_calls/health_probe_future_call.dart';
import 'src/future_calls/retention_cleanup_future_call.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  // Initialize Serverpod and connect it with the generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Register background FutureCalls
  pod.registerFutureCall(EscalationFutureCall(), 'EscalationFutureCall');
  pod.registerFutureCall(HealthProbeFutureCall(), 'HealthProbeFutureCall');
  pod.registerFutureCall(RetentionCleanupFutureCall(), 'RetentionCleanupFutureCall');

  // Start the server.
  await pod.start();
}
