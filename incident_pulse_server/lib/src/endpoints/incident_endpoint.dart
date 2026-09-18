import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class IncidentEndpoint extends Endpoint {
  /// Fetches all active / unresolved incidents
  Future<List<Incident>> getActiveIncidents(Session session) async {
    return await Incident.db.find(
      session,
      where: (t) => t.status.notEquals('resolved'),
      orderBy: (t) => t.triggeredAt,
      orderDescending: true,
    );
  }

  /// Fetches incident history for a specific service
  Future<List<Incident>> getServiceIncidents(
    Session session, {
    required int serviceId,
    int limit = 50,
  }) async {
    return await Incident.db.find(
      session,
      where: (t) => t.serviceId.equals(serviceId),
      orderBy: (t) => t.triggeredAt,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Manually creates a new incident
  Future<Incident> createIncident(
    Session session, {
    required int serviceId,
    required String title,
    required String description,
    required String severity,
    String source = 'manual',
  }) async {
    final now = DateTime.now();
    final incident = Incident(
      serviceId: serviceId,
      title: title,
      description: description,
      severity: severity,
      status: 'triggered',
      source: source,
      triggeredAt: now,
    );

    final created = await Incident.db.insertRow(session, incident);

    // Record initial event in the war-room timeline
    final event = IncidentEvent(
      incidentId: created.id!,
      author: 'System',
      eventType: 'status_change',
      content: 'Incident triggered with severity: $severity',
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    // Broadcast update across WebSockets channel for this incident
    session.messages.postMessage(
      'incident_${created.id}',
      event,
    );

    return created;
  }

  /// Acknowledges an incident by a responder
  Future<Incident?> acknowledgeIncident(
    Session session, {
    required int incidentId,
    required String responderName,
  }) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) return null;

    final now = DateTime.now();
    final updated = incident.copyWith(
      status: 'acknowledged',
      acknowledgedAt: now,
    );
    final saved = await Incident.db.updateRow(session, updated);

    final event = IncidentEvent(
      incidentId: incidentId,
      author: responderName,
      eventType: 'status_change',
      content: 'Incident acknowledged by $responderName',
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    session.messages.postMessage('incident_$incidentId', event);
    return saved;
  }

  /// Resolves an incident with root cause documentation
  Future<Incident?> resolveIncident(
    Session session, {
    required int incidentId,
    required String resolverName,
    required String rootCause,
  }) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) return null;

    final now = DateTime.now();
    final updated = incident.copyWith(
      status: 'resolved',
      rootCause: rootCause,
      resolvedAt: now,
    );
    final saved = await Incident.db.updateRow(session, updated);

    final event = IncidentEvent(
      incidentId: incidentId,
      author: resolverName,
      eventType: 'status_change',
      content: 'Incident resolved by $resolverName. Root Cause: $rootCause',
      createdAt: now,
    );
    await IncidentEvent.db.insertRow(session, event);

    session.messages.postMessage('incident_$incidentId', event);
    return saved;
  }
}
