import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Generic AI Telemetry & Autonomous Assistant Bridge Endpoint.
///
/// Enables external AI agents, autonomous diagnosis tools, or custom LLM bots
/// to consume system health telemetry and attach diagnostic insights to War Rooms.
///
/// TENANT PRIVACY & ISOLATION POLICY:
/// - Only services with `isInternalOwner == true` or `enableAiBridge == true`
///   are exposed through this endpoint.
/// - Customer data that has not explicitly opted-in is strictly blocked.
class AiTelemetryEndpoint extends Endpoint {
  /// Verifies optional pre-shared agent authentication key
  bool _isAuthorized(Session session, String? authToken) {
    final configuredKey = Platform.environment['AI_TELEMETRY_BRIDGE_KEY'];
    if (configuredKey == null || configuredKey.isEmpty) {
      return true; // Local development mode
    }
    return authToken == configuredKey;
  }

  /// Retrieves an aggregated reliability and health summary for opted-in services
  Future<Map<String, dynamic>> getTelemetrySummary(
    Session session, {
    String? authToken,
  }) async {
    if (!_isAuthorized(session, authToken)) {
      throw StateError('Unauthorized: Invalid AI telemetry bridge key.');
    }

    // Strictly filter for internal or explicitly opted-in services
    final services = await Service.db.find(
      session,
      where: (t) => t.isInternalOwner.equals(true) | t.enableAiBridge.equals(true),
    );

    final serviceIds = services.map((s) => s.id!).toSet();

    final activeIncidents = await Incident.db.find(
      session,
      where: (t) => t.status.notEquals('resolved') & t.serviceId.inSet(serviceIds),
    );

    int operational = 0;
    int degraded = 0;
    int down = 0;

    for (final s in services) {
      if (s.status == 'operational') {
        operational++;
      } else if (s.status == 'degraded') {
        degraded++;
      } else {
        down++;
      }
    }

    return {
      'totalAllowedServices': services.length,
      'operationalCount': operational,
      'degradedCount': degraded,
      'downCount': down,
      'activeIncidentCount': activeIncidents.length,
      'services': services.map((s) => {
        'id': s.id,
        'name': s.name,
        'slug': s.slug,
        'status': s.status,
        'isInternalOwner': s.isInternalOwner,
        'enableAiBridge': s.enableAiBridge,
        'lastPingAt': s.lastPingAt?.toIso8601String(),
      }).toList(),
      'criticalIncidents': activeIncidents
          .where((i) => i.severity == 'critical')
          .map((i) => {
            'id': i.id,
            'serviceId': i.serviceId,
            'title': i.title,
            'severity': i.severity,
            'triggeredAt': i.triggeredAt.toIso8601String(),
          }).toList(),
    };
  }

  /// Submits an autonomous AI diagnosis, stacktrace breakdown, or suggested remediation diff
  /// into the War Room.
  Future<IncidentEvent> submitAiDiagnosis(
    Session session, {
    required int incidentId,
    required String agentName,
    required String diagnosisMarkdown,
    String? suggestedDiff,
    String? authToken,
  }) async {
    if (!_isAuthorized(session, authToken)) {
      throw StateError('Unauthorized: Invalid AI telemetry bridge key.');
    }

    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) {
      throw ArgumentError('Incident #$incidentId not found');
    }

    final service = await Service.db.findById(session, incident.serviceId);
    if (service == null) {
      throw ArgumentError('Associated service not found');
    }

    if (!service.isInternalOwner && !service.enableAiBridge) {
      session.log(
        'SECURITY ALERT: Unauthorized AI diagnosis attempt on service #${service.id} without opt-in consent.',
        level: LogLevel.warning,
      );
      throw StateError('Tenant privacy policy: AI bridge is disabled for this service.');
    }

    final now = DateTime.now();
    final contentBuffer = StringBuffer()
      ..writeln('### 🤖 AI Diagnosis ($agentName)')
      ..writeln(diagnosisMarkdown);

    if (suggestedDiff != null && suggestedDiff.trim().isNotEmpty) {
      contentBuffer
        ..writeln('\n#### 🛠️ Suggested Remediation Diff')
        ..writeln('```diff')
        ..writeln(suggestedDiff.trim())
        ..writeln('```');
    }

    final event = IncidentEvent(
      incidentId: incidentId,
      author: agentName,
      eventType: 'ai_insight',
      content: contentBuffer.toString(),
      isRedacted: false,
      createdAt: now,
    );

    final saved = await IncidentEvent.db.insertRow(session, event);

    // Broadcast live event into the War Room WebSockets channel
    session.messages.postMessage(
      'incident_$incidentId',
      saved,
    );

    return saved;
  }

  /// Records a structured reliability report for historical research
  Future<ReliabilityReport> recordReliabilityReport(
    Session session, {
    required int serviceId,
    required double uptimePercent,
    required int incidentCount,
    required double mttrMinutes,
    required double healthScore,
    required String reportSummary,
    String? authToken,
  }) async {
    if (!_isAuthorized(session, authToken)) {
      throw StateError('Unauthorized: Invalid AI telemetry bridge key.');
    }

    final service = await Service.db.findById(session, serviceId);
    if (service == null || (!service.isInternalOwner && !service.enableAiBridge)) {
      throw StateError('Tenant privacy policy: Cannot record reliability metrics for unconsented service.');
    }

    final report = ReliabilityReport(
      serviceId: serviceId,
      uptimePercent: uptimePercent,
      incidentCount: incidentCount,
      mttrMinutes: mttrMinutes,
      healthScore: healthScore,
      reportSummary: reportSummary,
      generatedAt: DateTime.now(),
    );

    return await ReliabilityReport.db.insertRow(session, report);
  }
}
