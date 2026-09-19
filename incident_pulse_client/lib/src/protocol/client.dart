/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:incident_pulse_client/src/protocol/incident.dart' as _ii2a5p2r;
import 'package:incident_pulse_client/src/protocol/incident_event.dart'
    as _i7bypfhu;
import 'package:incident_pulse_client/src/protocol/reliability_report.dart'
    as _izi1yss6;
import 'package:incident_pulse_client/src/protocol/service.dart' as _icu7ot0t;
import 'package:incident_pulse_client/src/protocol/webhook_subscription.dart'
    as _iwimdxih;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Generic AI Telemetry & Autonomous Assistant Bridge Endpoint.
///
/// Enables external AI agents, autonomous diagnosis tools, or custom LLM bots
/// to consume system health telemetry and attach diagnostic insights to War Rooms.
///
/// TENANT PRIVACY & ISOLATION POLICY:
/// - Only services with `isInternalOwner == true` or `enableAiBridge == true`
///   are exposed through this endpoint.
/// - Customer data that has not explicitly opted-in is strictly blocked.
/// {@category Endpoint}
class EndpointAiTelemetry extends _isc.EndpointRef {
  EndpointAiTelemetry(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'aiTelemetry';

  /// Retrieves an aggregated reliability and health summary for opted-in services
  _ida.Future<Map<String, dynamic>> getTelemetrySummary({String? authToken}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'aiTelemetry',
        'getTelemetrySummary',
        {'authToken': authToken},
      );

  /// Submits an autonomous AI diagnosis, stacktrace breakdown, or suggested remediation diff
  /// into the War Room.
  _ida.Future<_i7bypfhu.IncidentEvent> submitAiDiagnosis({
    required int incidentId,
    required String agentName,
    required String diagnosisMarkdown,
    String? suggestedDiff,
    String? authToken,
  }) =>
      caller.callServerEndpoint<_i7bypfhu.IncidentEvent>(
        'aiTelemetry',
        'submitAiDiagnosis',
        {
          'incidentId': incidentId,
          'agentName': agentName,
          'diagnosisMarkdown': diagnosisMarkdown,
          'suggestedDiff': suggestedDiff,
          'authToken': authToken,
        },
      );

  /// Records a structured reliability report for historical research
  _ida.Future<_izi1yss6.ReliabilityReport> recordReliabilityReport({
    required int serviceId,
    required double uptimePercent,
    required int incidentCount,
    required double mttrMinutes,
    required double healthScore,
    required String reportSummary,
    String? authToken,
  }) =>
      caller.callServerEndpoint<_izi1yss6.ReliabilityReport>(
        'aiTelemetry',
        'recordReliabilityReport',
        {
          'serviceId': serviceId,
          'uptimePercent': uptimePercent,
          'incidentCount': incidentCount,
          'mttrMinutes': mttrMinutes,
          'healthScore': healthScore,
          'reportSummary': reportSummary,
          'authToken': authToken,
        },
      );
}

/// {@category Endpoint}
class EndpointIncident extends _isc.EndpointRef {
  EndpointIncident(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'incident';

  /// Fetches all active / unresolved incidents
  _ida.Future<List<_ii2a5p2r.Incident>> getActiveIncidents() =>
      caller.callServerEndpoint<List<_ii2a5p2r.Incident>>(
        'incident',
        'getActiveIncidents',
        {},
      );

  /// Fetches incident history for a specific service
  _ida.Future<List<_ii2a5p2r.Incident>> getServiceIncidents({
    required int serviceId,
    required int limit,
  }) =>
      caller.callServerEndpoint<List<_ii2a5p2r.Incident>>(
        'incident',
        'getServiceIncidents',
        {
          'serviceId': serviceId,
          'limit': limit,
        },
      );

  /// Manually creates a new incident
  _ida.Future<_ii2a5p2r.Incident> createIncident({
    required int serviceId,
    required String title,
    required String description,
    required String severity,
    required String source,
  }) =>
      caller.callServerEndpoint<_ii2a5p2r.Incident>(
        'incident',
        'createIncident',
        {
          'serviceId': serviceId,
          'title': title,
          'description': description,
          'severity': severity,
          'source': source,
        },
      );

  /// Acknowledges an incident by a responder
  _ida.Future<_ii2a5p2r.Incident?> acknowledgeIncident({
    required int incidentId,
    required String responderName,
  }) =>
      caller.callServerEndpoint<_ii2a5p2r.Incident?>(
        'incident',
        'acknowledgeIncident',
        {
          'incidentId': incidentId,
          'responderName': responderName,
        },
      );

  /// Resolves an incident with root cause documentation
  _ida.Future<_ii2a5p2r.Incident?> resolveIncident({
    required int incidentId,
    required String resolverName,
    required String rootCause,
  }) =>
      caller.callServerEndpoint<_ii2a5p2r.Incident?>(
        'incident',
        'resolveIncident',
        {
          'incidentId': incidentId,
          'resolverName': resolverName,
          'rootCause': rootCause,
        },
      );
}

/// {@category Endpoint}
class EndpointService extends _isc.EndpointRef {
  EndpointService(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'service';

  /// Lists all registered services and their current status
  _ida.Future<List<_icu7ot0t.Service>> listServices() =>
      caller.callServerEndpoint<List<_icu7ot0t.Service>>(
        'service',
        'listServices',
        {},
      );

  /// Registers a new service/micro-SaaS to monitor.
  ///
  /// DEFAULT PRIVACY POLICIES:
  /// - `enableAiBridge`: FALSE (customers must explicitly opt-in).
  /// - `dataRetentionDays`: 90 days.
  /// - `redactPii`: TRUE (scrubs tokens, credentials, and customer personal data).
  _ida.Future<_icu7ot0t.Service> createService({
    required String name,
    required String slug,
    String? pingUrl,
    Map<String, String>? pingHeaders,
    required int checkIntervalSeconds,
    required bool isInternalOwner,
    required bool enableAiBridge,
    required int dataRetentionDays,
    required bool redactPii,
  }) =>
      caller.callServerEndpoint<_icu7ot0t.Service>(
        'service',
        'createService',
        {
          'name': name,
          'slug': slug,
          'pingUrl': pingUrl,
          'pingHeaders': pingHeaders,
          'checkIntervalSeconds': checkIntervalSeconds,
          'isInternalOwner': isInternalOwner,
          'enableAiBridge': enableAiBridge,
          'dataRetentionDays': dataRetentionDays,
          'redactPii': redactPii,
        },
      );

  /// Updates synthetic health ping configuration (URL, headers, check interval)
  _ida.Future<_icu7ot0t.Service?> updateServicePing({
    required int serviceId,
    String? pingUrl,
    Map<String, String>? pingHeaders,
    int? checkIntervalSeconds,
  }) =>
      caller.callServerEndpoint<_icu7ot0t.Service?>(
        'service',
        'updateServicePing',
        {
          'serviceId': serviceId,
          'pingUrl': pingUrl,
          'pingHeaders': pingHeaders,
          'checkIntervalSeconds': checkIntervalSeconds,
        },
      );

  /// Updates status of a service
  _ida.Future<_icu7ot0t.Service?> updateServiceStatus({
    required int serviceId,
    required String status,
  }) =>
      caller.callServerEndpoint<_icu7ot0t.Service?>(
        'service',
        'updateServiceStatus',
        {
          'serviceId': serviceId,
          'status': status,
        },
      );

  /// Updates tenant privacy, AI bridge opt-in, and compliance retention settings
  _ida.Future<_icu7ot0t.Service?> updatePrivacyAndRetention({
    required int serviceId,
    required bool enableAiBridge,
    required int dataRetentionDays,
    required bool redactPii,
  }) =>
      caller.callServerEndpoint<_icu7ot0t.Service?>(
        'service',
        'updatePrivacyAndRetention',
        {
          'serviceId': serviceId,
          'enableAiBridge': enableAiBridge,
          'dataRetentionDays': dataRetentionDays,
          'redactPii': redactPii,
        },
      );

  /// GDPR / CCPA Article 17 "Right to Erasure"
  /// Purges all raw payloads, sensitive headers, and timeline chat for this service
  /// while retaining anonymized post-mortem incident metrics.
  _ida.Future<bool> purgeServiceHistory({
    required int serviceId,
    required bool purgeEntireIncidents,
  }) =>
      caller.callServerEndpoint<bool>(
        'service',
        'purgeServiceHistory',
        {
          'serviceId': serviceId,
          'purgeEntireIncidents': purgeEntireIncidents,
        },
      );
}

/// {@category Endpoint}
class EndpointWarRoom extends _isc.EndpointRef {
  EndpointWarRoom(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'warRoom';

  /// Realtime WebSockets stream: Emits timeline events, live chat notes,
  /// and status changes for an active incident War Room.
  _ida.Stream<_i7bypfhu.IncidentEvent> streamWarRoom(int incidentId) =>
      caller.callStreamingServerEndpoint<_ida.Stream<_i7bypfhu.IncidentEvent>,
          _i7bypfhu.IncidentEvent>(
        'warRoom',
        'streamWarRoom',
        {'incidentId': incidentId},
        {},
      );

  /// Posts a note, diagnostic message, or chat entry into the War Room
  _ida.Future<_i7bypfhu.IncidentEvent> postWarRoomNote({
    required int incidentId,
    required String author,
    required String content,
    required String eventType,
  }) =>
      caller.callServerEndpoint<_i7bypfhu.IncidentEvent>(
        'warRoom',
        'postWarRoomNote',
        {
          'incidentId': incidentId,
          'author': author,
          'content': content,
          'eventType': eventType,
        },
      );
}

/// {@category Endpoint}
class EndpointWebhook extends _isc.EndpointRef {
  EndpointWebhook(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'webhook';

  /// Public webhook ingress endpoint.
  /// Authenticates using the service's webhookKey, applies PII redaction,
  /// sets compliance data retention expiration, and creates an incident.
  _ida.Future<bool> ingestWebhook({
    required String webhookKey,
    required String source,
    required String rawPayloadJson,
  }) =>
      caller.callServerEndpoint<bool>(
        'webhook',
        'ingestWebhook',
        {
          'webhookKey': webhookKey,
          'source': source,
          'rawPayloadJson': rawPayloadJson,
        },
      );
}

/// {@category Endpoint}
class EndpointWebhookSubscription extends _isc.EndpointRef {
  EndpointWebhookSubscription(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'webhookSubscription';

  /// Lists all active outbound webhook subscriptions, optionally filtered by service
  _ida.Future<List<_iwimdxih.WebhookSubscription>> listSubscriptions(
          {int? serviceId}) =>
      caller.callServerEndpoint<List<_iwimdxih.WebhookSubscription>>(
        'webhookSubscription',
        'listSubscriptions',
        {'serviceId': serviceId},
      );

  /// Registers a new generic outbound webhook subscription
  _ida.Future<_iwimdxih.WebhookSubscription> createSubscription({
    required String name,
    required String targetUrl,
    int? serviceId,
    String? secretKey,
    Map<String, String>? customHeaders,
    List<String>? events,
  }) =>
      caller.callServerEndpoint<_iwimdxih.WebhookSubscription>(
        'webhookSubscription',
        'createSubscription',
        {
          'name': name,
          'targetUrl': targetUrl,
          'serviceId': serviceId,
          'secretKey': secretKey,
          'customHeaders': customHeaders,
          'events': events,
        },
      );

  /// Deletes a webhook subscription
  _ida.Future<bool> deleteSubscription({required int subscriptionId}) =>
      caller.callServerEndpoint<bool>(
        'webhookSubscription',
        'deleteSubscription',
        {'subscriptionId': subscriptionId},
      );

  /// Sends a test ping to verify webhook target connectivity and HMAC verification
  _ida.Future<Map<String, dynamic>> testSubscription(
          {required int subscriptionId}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'webhookSubscription',
        'testSubscription',
        {'subscriptionId': subscriptionId},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i312scxx.Caller(client);
  }

  late final _i312scxx.Caller auth;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
          host,
          _il2as5qe.Protocol(),
          securityContext: securityContext,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
          httpClientOverride: httpClientOverride,
        ) {
    aiTelemetry = EndpointAiTelemetry(this);
    incident = EndpointIncident(this);
    service = EndpointService(this);
    warRoom = EndpointWarRoom(this);
    webhook = EndpointWebhook(this);
    webhookSubscription = EndpointWebhookSubscription(this);
    modules = Modules(this);
  }

  late final EndpointAiTelemetry aiTelemetry;

  late final EndpointIncident incident;

  late final EndpointService service;

  late final EndpointWarRoom warRoom;

  late final EndpointWebhook webhook;

  late final EndpointWebhookSubscription webhookSubscription;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
        'aiTelemetry': aiTelemetry,
        'incident': incident,
        'service': service,
        'warRoom': warRoom,
        'webhook': webhook,
        'webhookSubscription': webhookSubscription,
      };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
