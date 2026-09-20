import 'dart:io';
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

    // Cloudflare Zero Trust Service Token credentials for n8n
    final cfId = session.passwords['CF_ACCESS_CLIENT_ID'] ??
        Platform.environment['CF_ACCESS_CLIENT_ID'];
    final cfSecret = session.passwords['CF_ACCESS_CLIENT_SECRET'] ??
        Platform.environment['CF_ACCESS_CLIENT_SECRET'];

    final cfHeaders = (cfId != null && cfSecret != null && cfId.isNotEmpty && cfSecret.isNotEmpty)
        ? {
            'CF-Access-Client-Id': cfId,
            'CF-Access-Client-Secret': cfSecret,
          }
        : null;

    final n8nMatches = existing.where((s) => s.slug == 'n8n-hub');
    final n8nService = n8nMatches.isNotEmpty ? n8nMatches.first : null;

    if (n8nService == null) {
      await Service.db.insertRow(
        session,
        Service(
          name: 'n8n Automation Hub',
          slug: 'n8n-hub',
          webhookKey: 'whk_seed_n8n_hub_${now.millisecondsSinceEpoch}',
          pingUrl: 'https://n8n.ryanguthrie.com',
          pingHeaders: cfHeaders,
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
    } else if (cfHeaders != null && (n8nService.pingHeaders == null || n8nService.pingHeaders!.isEmpty)) {
      final updated = n8nService.copyWith(pingHeaders: cfHeaders);
      await Service.db.updateRow(session, updated);
      session.log('Updated n8n Automation Hub with Cloudflare Access Service Token headers');
    }

    // Seed outbound Discord webhook subscription if configured
    final discordUrl = session.passwords['DISCORD_WEBHOOK_URL'] ??
        Platform.environment['DISCORD_WEBHOOK_URL'];

    if (discordUrl != null && discordUrl.isNotEmpty) {
      final existingHooks = await WebhookSubscription.db.find(
        session,
        where: (t) => t.targetUrl.equals(discordUrl),
      );
      if (existingHooks.isEmpty) {
        await WebhookSubscription.db.insertRow(
          session,
          WebhookSubscription(
            name: 'Discord Ops Alerts',
            targetUrl: discordUrl,
            serviceId: null, // Global alerts for all services
            events: [
              'incident.triggered',
              'incident.acknowledged',
              'incident.escalated',
              'incident.resolved',
            ],
            isActive: true,
            createdAt: now,
          ),
        );
        session.log('Seeded baseline Discord outbound webhook subscription');
      }
    }
  } catch (e) {
    session.log('Baseline service seed notice: $e', level: LogLevel.info);
  } finally {
    await session.close();
  }
}
