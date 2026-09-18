import 'package:serverpod/serverpod.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  // Initialize Serverpod and connect it with the generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Start the server.
  await pod.start();

  // Automatically seed baseline internal services if not yet present
  await _seedBaselineServices(pod);
}

/// Idempotently seeds initial monitored services for internal owner
Future<void> _seedBaselineServices(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    final existing = await Service.db.find(session);
    final existingSlugs = existing.map((s) => s.slug).toSet();
    final now = DateTime.now();

    if (!existingSlugs.contains('ryan-portfolio')) {
      await Service.db.insertRow(
        session,
        Service(
          name: 'Ryan Guthrie Portfolio',
          slug: 'ryan-portfolio',
          webhookKey: 'whk_seed_ryan_portfolio_${now.millisecondsSinceEpoch}',
          pingUrl: 'https://ryanguthrie.com',
          status: 'operational',
          checkIntervalSeconds: 60,
          isInternalOwner: true,
          enableAiBridge: true,
          dataRetentionDays: 365,
          redactPii: true,
          createdAt: now,
        ),
      );
      session.log('Seeded baseline service: Ryan Guthrie Portfolio (https://ryanguthrie.com)');
    }

    if (!existingSlugs.contains('n8n-hub')) {
      await Service.db.insertRow(
        session,
        Service(
          name: 'n8n Automation Hub',
          slug: 'n8n-hub',
          webhookKey: 'whk_seed_n8n_hub_${now.millisecondsSinceEpoch}',
          pingUrl: 'https://n8n.ryanguthrie.com',
          status: 'operational',
          checkIntervalSeconds: 60,
          isInternalOwner: true,
          enableAiBridge: true,
          dataRetentionDays: 365,
          redactPii: true,
          createdAt: now,
        ),
      );
      session.log('Seeded baseline service: n8n Automation Hub (https://n8n.ryanguthrie.com)');
    }
  } catch (e) {
    session.log('Baseline service seed notice: $e', level: LogLevel.info);
  } finally {
    await session.close();
  }
}
