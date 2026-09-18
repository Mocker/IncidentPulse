import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ServiceEndpoint extends Endpoint {
  /// Lists all registered services and their current status
  Future<List<Service>> listServices(Session session) async {
    return await Service.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  /// Registers a new service/micro-SaaS to monitor.
  /// 
  /// DEFAULT PRIVACY POLICIES:
  /// - `enableAiBridge`: FALSE (customers must explicitly opt-in).
  /// - `dataRetentionDays`: 90 days.
  /// - `redactPii`: TRUE (scrubs tokens, credentials, and customer personal data).
  Future<Service> createService(
    Session session, {
    required String name,
    required String slug,
    String? pingUrl,
    int checkIntervalSeconds = 60,
    bool isInternalOwner = false,
    bool enableAiBridge = false,
    int dataRetentionDays = 90,
    bool redactPii = true,
  }) async {
    final webhookKey = _generateSecureToken(32);
    final now = DateTime.now();

    final service = Service(
      name: name,
      slug: slug.toLowerCase().replaceAll(' ', '-'),
      webhookKey: webhookKey,
      pingUrl: pingUrl,
      status: 'operational',
      checkIntervalSeconds: checkIntervalSeconds,
      isInternalOwner: isInternalOwner,
      enableAiBridge: isInternalOwner ? true : enableAiBridge,
      dataRetentionDays: dataRetentionDays,
      redactPii: redactPii,
      createdAt: now,
    );

    return await Service.db.insertRow(session, service);
  }

  /// Updates status of a service
  Future<Service?> updateServiceStatus(
    Session session, {
    required int serviceId,
    required String status,
  }) async {
    final service = await Service.db.findById(session, serviceId);
    if (service == null) return null;

    final updated = service.copyWith(status: status);
    return await Service.db.updateRow(session, updated);
  }

  /// Updates tenant privacy, AI bridge opt-in, and compliance retention settings
  Future<Service?> updatePrivacyAndRetention(
    Session session, {
    required int serviceId,
    required bool enableAiBridge,
    required int dataRetentionDays,
    required bool redactPii,
  }) async {
    final service = await Service.db.findById(session, serviceId);
    if (service == null) return null;

    final updated = service.copyWith(
      enableAiBridge: enableAiBridge,
      dataRetentionDays: dataRetentionDays,
      redactPii: redactPii,
    );

    session.log(
      'Updated privacy & retention for service #${service.id}: AiBridge=$enableAiBridge, RetentionDays=$dataRetentionDays, RedactPII=$redactPii',
      level: LogLevel.info,
    );

    return await Service.db.updateRow(session, updated);
  }

  /// GDPR / CCPA Article 17 "Right to Erasure"
  /// Purges all raw payloads, sensitive headers, and timeline chat for this service
  /// while retaining anonymized post-mortem incident metrics.
  Future<bool> purgeServiceHistory(
    Session session, {
    required int serviceId,
    bool purgeEntireIncidents = false,
  }) async {
    final service = await Service.db.findById(session, serviceId);
    if (service == null) return false;

    final incidents = await Incident.db.find(
      session,
      where: (t) => t.serviceId.equals(serviceId),
    );

    for (final inc in incidents) {
      if (purgeEntireIncidents) {
        // Delete child events first, then the incident
        await IncidentEvent.db.deleteWhere(
          session,
          where: (t) => t.incidentId.equals(inc.id!),
        );
        await Incident.db.deleteRow(session, inc);
      } else {
        // Redact and scrub sensitive data only, preserving incident count and MTTR
        final sanitized = inc.copyWith(
          rawPayload: '[PURGED: Requested under GDPR Right to Erasure]',
          description: '[Redacted under tenant data privacy policy]',
          isRedacted: true,
        );
        await Incident.db.updateRow(session, sanitized);

        await IncidentEvent.db.deleteWhere(
          session,
          where: (t) => t.incidentId.equals(inc.id!),
        );
      }
    }

    session.log(
      'Executed data purge for service #${service.id}. EntireIncidents=$purgeEntireIncidents',
      level: LogLevel.info,
    );

    return true;
  }

  /// Helper to generate random webhook API keys
  String _generateSecureToken(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();
    return List.generate(length, (index) => chars[rnd.nextInt(chars.length)]).join();
  }
}
