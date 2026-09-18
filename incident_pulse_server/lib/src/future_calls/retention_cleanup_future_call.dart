import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Automated compliance worker that runs on a schedule to enforce
/// tenant data retention windows and legal regulations (GDPR, CCPA, SOC2).
///
/// Striking the balance:
/// - Customers can still review past incident history, MTTR metrics, and root-cause post-mortems.
/// - Raw webhook payloads, sensitive HTTP headers, and granular PII are purged/redacted
///   once the configured retention window (e.g. 30, 90, 180, 365 days) expires.
class RetentionCleanupFutureCall extends FutureCall {
  @override
  Future<void> run(Session session, dynamic object) async {
    final now = DateTime.now();
    session.log('Running automated data retention and compliance cleanup...', level: LogLevel.info);

    // 1. Find incidents past their retention expiration date that haven't been redacted yet
    final expiredIncidents = await Incident.db.find(
      session,
      where: (t) => (t.expiresAt <= now) & t.isRedacted.equals(false),
      limit: 500,
    );

    int sanitizedCount = 0;
    for (final inc in expiredIncidents) {
      // Scrub raw payload and mark incident as redacted
      final sanitized = inc.copyWith(
        rawPayload: '[PURGED: Expired under tenant data retention policy]',
        description: 'Incident metadata preserved for post-mortem analysis. Raw payload purged.',
        isRedacted: true,
      );
      await Incident.db.updateRow(session, sanitized);

      // Scrub timeline event details for this incident
      final events = await IncidentEvent.db.find(
        session,
        where: (t) => t.incidentId.equals(inc.id!) & t.isRedacted.equals(false),
      );

      for (final event in events) {
        if (event.eventType == 'alert' || event.author.startsWith('Webhook')) {
          final scrubbedEvent = event.copyWith(
            content: '[Payload purged per retention policy]',
            isRedacted: true,
          );
          await IncidentEvent.db.updateRow(session, scrubbedEvent);
        }
      }

      sanitizedCount++;
    }

    session.log(
      'Data retention cleanup complete: Sanitized $sanitizedCount expired incidents.',
      level: LogLevel.info,
    );

    // Re-schedule for next 24 hours
    await session.serverpod.futureCallWithDelay(
      'RetentionCleanupFutureCall',
      null,
      const Duration(hours: 24),
    );
  }
}
