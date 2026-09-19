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
import 'package:incident_pulse_server/src/generated/future_calls.dart'
    as _i8ipz27y;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import '../endpoints/ai_telemetry_endpoint.dart' as _i395avo5;
import '../endpoints/incident_endpoint.dart' as _idvfe0v9;
import '../endpoints/service_endpoint.dart' as _ihicv58o;
import '../endpoints/war_room_endpoint.dart' as _ia8zoqqr;
import '../endpoints/webhook_endpoint.dart' as _iy6zjke8;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'aiTelemetry': _i395avo5.AiTelemetryEndpoint()
        ..initialize(
          server,
          'aiTelemetry',
          null,
        ),
      'incident': _idvfe0v9.IncidentEndpoint()
        ..initialize(
          server,
          'incident',
          null,
        ),
      'service': _ihicv58o.ServiceEndpoint()
        ..initialize(
          server,
          'service',
          null,
        ),
      'warRoom': _ia8zoqqr.WarRoomEndpoint()
        ..initialize(
          server,
          'warRoom',
          null,
        ),
      'webhook': _iy6zjke8.WebhookEndpoint()
        ..initialize(
          server,
          'webhook',
          null,
        ),
    };
    connectors['aiTelemetry'] = _is.EndpointConnector(
      name: 'aiTelemetry',
      endpoint: endpoints['aiTelemetry']!,
      methodConnectors: {
        'getTelemetrySummary': _is.MethodConnector(
          name: 'getTelemetrySummary',
          params: {
            'authToken': _is.ParameterDescription(
              name: 'authToken',
              type: _is.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['aiTelemetry'] as _i395avo5.AiTelemetryEndpoint)
                  .getTelemetrySummary(
            session,
            authToken: params['authToken'],
          ),
        ),
        'submitAiDiagnosis': _is.MethodConnector(
          name: 'submitAiDiagnosis',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'agentName': _is.ParameterDescription(
              name: 'agentName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'diagnosisMarkdown': _is.ParameterDescription(
              name: 'diagnosisMarkdown',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'suggestedDiff': _is.ParameterDescription(
              name: 'suggestedDiff',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'authToken': _is.ParameterDescription(
              name: 'authToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['aiTelemetry'] as _i395avo5.AiTelemetryEndpoint)
                  .submitAiDiagnosis(
            session,
            incidentId: params['incidentId'],
            agentName: params['agentName'],
            diagnosisMarkdown: params['diagnosisMarkdown'],
            suggestedDiff: params['suggestedDiff'],
            authToken: params['authToken'],
          ),
        ),
        'recordReliabilityReport': _is.MethodConnector(
          name: 'recordReliabilityReport',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'uptimePercent': _is.ParameterDescription(
              name: 'uptimePercent',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'incidentCount': _is.ParameterDescription(
              name: 'incidentCount',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'mttrMinutes': _is.ParameterDescription(
              name: 'mttrMinutes',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'healthScore': _is.ParameterDescription(
              name: 'healthScore',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'reportSummary': _is.ParameterDescription(
              name: 'reportSummary',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'authToken': _is.ParameterDescription(
              name: 'authToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['aiTelemetry'] as _i395avo5.AiTelemetryEndpoint)
                  .recordReliabilityReport(
            session,
            serviceId: params['serviceId'],
            uptimePercent: params['uptimePercent'],
            incidentCount: params['incidentCount'],
            mttrMinutes: params['mttrMinutes'],
            healthScore: params['healthScore'],
            reportSummary: params['reportSummary'],
            authToken: params['authToken'],
          ),
        ),
      },
    );
    connectors['incident'] = _is.EndpointConnector(
      name: 'incident',
      endpoint: endpoints['incident']!,
      methodConnectors: {
        'getActiveIncidents': _is.MethodConnector(
          name: 'getActiveIncidents',
          params: {},
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .getActiveIncidents(session),
        ),
        'getServiceIncidents': _is.MethodConnector(
          name: 'getServiceIncidents',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .getServiceIncidents(
            session,
            serviceId: params['serviceId'],
            limit: params['limit'],
          ),
        ),
        'createIncident': _is.MethodConnector(
          name: 'createIncident',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'severity': _is.ParameterDescription(
              name: 'severity',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .createIncident(
            session,
            serviceId: params['serviceId'],
            title: params['title'],
            description: params['description'],
            severity: params['severity'],
            source: params['source'],
          ),
        ),
        'acknowledgeIncident': _is.MethodConnector(
          name: 'acknowledgeIncident',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'responderName': _is.ParameterDescription(
              name: 'responderName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .acknowledgeIncident(
            session,
            incidentId: params['incidentId'],
            responderName: params['responderName'],
          ),
        ),
        'resolveIncident': _is.MethodConnector(
          name: 'resolveIncident',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'resolverName': _is.ParameterDescription(
              name: 'resolverName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'rootCause': _is.ParameterDescription(
              name: 'rootCause',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['incident'] as _idvfe0v9.IncidentEndpoint)
                  .resolveIncident(
            session,
            incidentId: params['incidentId'],
            resolverName: params['resolverName'],
            rootCause: params['rootCause'],
          ),
        ),
      },
    );
    connectors['service'] = _is.EndpointConnector(
      name: 'service',
      endpoint: endpoints['service']!,
      methodConnectors: {
        'listServices': _is.MethodConnector(
          name: 'listServices',
          params: {},
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['service'] as _ihicv58o.ServiceEndpoint)
                  .listServices(session),
        ),
        'createService': _is.MethodConnector(
          name: 'createService',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'slug': _is.ParameterDescription(
              name: 'slug',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'pingUrl': _is.ParameterDescription(
              name: 'pingUrl',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'pingHeaders': _is.ParameterDescription(
              name: 'pingHeaders',
              type: _is.getType<Map<String, String>?>(),
              nullable: true,
            ),
            'checkIntervalSeconds': _is.ParameterDescription(
              name: 'checkIntervalSeconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'isInternalOwner': _is.ParameterDescription(
              name: 'isInternalOwner',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'enableAiBridge': _is.ParameterDescription(
              name: 'enableAiBridge',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'dataRetentionDays': _is.ParameterDescription(
              name: 'dataRetentionDays',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'redactPii': _is.ParameterDescription(
              name: 'redactPii',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['service'] as _ihicv58o.ServiceEndpoint).createService(
            session,
            name: params['name'],
            slug: params['slug'],
            pingUrl: params['pingUrl'],
            pingHeaders: params['pingHeaders'],
            checkIntervalSeconds: params['checkIntervalSeconds'],
            isInternalOwner: params['isInternalOwner'],
            enableAiBridge: params['enableAiBridge'],
            dataRetentionDays: params['dataRetentionDays'],
            redactPii: params['redactPii'],
          ),
        ),
        'updateServicePing': _is.MethodConnector(
          name: 'updateServicePing',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pingUrl': _is.ParameterDescription(
              name: 'pingUrl',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'pingHeaders': _is.ParameterDescription(
              name: 'pingHeaders',
              type: _is.getType<Map<String, String>?>(),
              nullable: true,
            ),
            'checkIntervalSeconds': _is.ParameterDescription(
              name: 'checkIntervalSeconds',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['service'] as _ihicv58o.ServiceEndpoint)
                  .updateServicePing(
            session,
            serviceId: params['serviceId'],
            pingUrl: params['pingUrl'],
            pingHeaders: params['pingHeaders'],
            checkIntervalSeconds: params['checkIntervalSeconds'],
          ),
        ),
        'updateServiceStatus': _is.MethodConnector(
          name: 'updateServiceStatus',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['service'] as _ihicv58o.ServiceEndpoint)
                  .updateServiceStatus(
            session,
            serviceId: params['serviceId'],
            status: params['status'],
          ),
        ),
        'updatePrivacyAndRetention': _is.MethodConnector(
          name: 'updatePrivacyAndRetention',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'enableAiBridge': _is.ParameterDescription(
              name: 'enableAiBridge',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'dataRetentionDays': _is.ParameterDescription(
              name: 'dataRetentionDays',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'redactPii': _is.ParameterDescription(
              name: 'redactPii',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['service'] as _ihicv58o.ServiceEndpoint)
                  .updatePrivacyAndRetention(
            session,
            serviceId: params['serviceId'],
            enableAiBridge: params['enableAiBridge'],
            dataRetentionDays: params['dataRetentionDays'],
            redactPii: params['redactPii'],
          ),
        ),
        'purgeServiceHistory': _is.MethodConnector(
          name: 'purgeServiceHistory',
          params: {
            'serviceId': _is.ParameterDescription(
              name: 'serviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'purgeEntireIncidents': _is.ParameterDescription(
              name: 'purgeEntireIncidents',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['service'] as _ihicv58o.ServiceEndpoint)
                  .purgeServiceHistory(
            session,
            serviceId: params['serviceId'],
            purgeEntireIncidents: params['purgeEntireIncidents'],
          ),
        ),
      },
    );
    connectors['warRoom'] = _is.EndpointConnector(
      name: 'warRoom',
      endpoint: endpoints['warRoom']!,
      methodConnectors: {
        'postWarRoomNote': _is.MethodConnector(
          name: 'postWarRoomNote',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'author': _is.ParameterDescription(
              name: 'author',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'eventType': _is.ParameterDescription(
              name: 'eventType',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['warRoom'] as _ia8zoqqr.WarRoomEndpoint)
                  .postWarRoomNote(
            session,
            incidentId: params['incidentId'],
            author: params['author'],
            content: params['content'],
            eventType: params['eventType'],
          ),
        ),
        'streamWarRoom': _is.MethodStreamConnector(
          name: 'streamWarRoom',
          params: {
            'incidentId': _is.ParameterDescription(
              name: 'incidentId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call: (
            _is.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['warRoom'] as _ia8zoqqr.WarRoomEndpoint).streamWarRoom(
            session,
            params['incidentId'],
          ),
        ),
      },
    );
    connectors['webhook'] = _is.EndpointConnector(
      name: 'webhook',
      endpoint: endpoints['webhook']!,
      methodConnectors: {
        'ingestWebhook': _is.MethodConnector(
          name: 'ingestWebhook',
          params: {
            'webhookKey': _is.ParameterDescription(
              name: 'webhookKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'rawPayloadJson': _is.ParameterDescription(
              name: 'rawPayloadJson',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['webhook'] as _iy6zjke8.WebhookEndpoint).ingestWebhook(
            session,
            webhookKey: params['webhookKey'],
            source: params['source'],
            rawPayloadJson: params['rawPayloadJson'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i1n3uhu0.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i8ipz27y.FutureCalls();
  }
}
