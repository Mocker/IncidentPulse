import 'package:serverpod/serverpod.dart';

/// Mutable server lifecycle state, populated by `server.dart` at startup.
/// Exposed read-only through [HealthEndpoint.heartbeat] so external monitors
/// and operators can tell which deployment is live and whether background
/// FutureCalls were registered — without needing log access.
class ServerHealth {
  static DateTime? startupAt;
  static bool retentionCleanupScheduled = false;
  static bool healthProbeScheduled = false;
}

/// Lightweight heartbeat for uptime monitors and deploy verification.
/// Public by design: reveals only liveness, startup time, and whether the
/// recurring FutureCall schedules registered — no incident or service data.
class HealthEndpoint extends Endpoint {
  Future<Map<String, dynamic>> heartbeat(Session session) async {
    final startup = ServerHealth.startupAt;
    return {
      'status': 'ok',
      'startupAt': startup?.toIso8601String(),
      'uptimeSeconds':
          startup == null ? null : DateTime.now().difference(startup).inSeconds,
      'futureCalls': {
        'retentionCleanupScheduled': ServerHealth.retentionCleanupScheduled,
        'healthProbeScheduled': ServerHealth.healthProbeScheduled,
      },
    };
  }
}
