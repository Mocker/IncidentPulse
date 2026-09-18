/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:incident_pulse_server/src/generated/incident.dart' as _ix5n0svs;
import 'package:incident_pulse_server/src/generated/service.dart' as _i9u6usup;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'escalation_policy.dart' as _iuema0oq;
import 'incident.dart' as _iy4wsyyx;
import 'incident_event.dart' as _icglyrab;
import 'reliability_report.dart' as _i48x74ln;
import 'service.dart' as _i70zm44a;
export 'escalation_policy.dart';
export 'incident.dart';
export 'incident_event.dart';
export 'reliability_report.dart';
export 'service.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
        _isp.TableDefinition(
          name: 'escalation_policy',
          dartName: 'EscalationPolicy',
          schema: 'public',
          module: 'incident_pulse',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'serviceId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'timeoutMinutes',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'notifyEmail',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'notifyWebhookUrl',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'isActive',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
          ],
          foreignKeys: [
            _isp.ForeignKeyDefinition(
              constraintName: 'escalation_policy_fk_0',
              columns: ['serviceId'],
              referenceTable: 'service',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: _isp.ForeignKeyAction.noAction,
              onDelete: _isp.ForeignKeyAction.noAction,
              matchType: null,
            )
          ],
          indexes: [],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'incident',
          dartName: 'Incident',
          schema: 'public',
          module: 'incident_pulse',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'serviceId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'title',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'description',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'severity',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'status',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'source',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'rootCause',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'rawPayload',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'isRedacted',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'expiresAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
              dartType: 'DateTime?',
            ),
            _isp.ColumnDefinition(
              name: 'triggeredAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'acknowledgedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
              dartType: 'DateTime?',
            ),
            _isp.ColumnDefinition(
              name: 'resolvedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
              dartType: 'DateTime?',
            ),
          ],
          foreignKeys: [
            _isp.ForeignKeyDefinition(
              constraintName: 'incident_fk_0',
              columns: ['serviceId'],
              referenceTable: 'service',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: _isp.ForeignKeyAction.noAction,
              onDelete: _isp.ForeignKeyAction.noAction,
              matchType: null,
            )
          ],
          indexes: [],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'incident_event',
          dartName: 'IncidentEvent',
          schema: 'public',
          module: 'incident_pulse',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'incidentId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'author',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'eventType',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'content',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'isRedacted',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [
            _isp.ForeignKeyDefinition(
              constraintName: 'incident_event_fk_0',
              columns: ['incidentId'],
              referenceTable: 'incident',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: _isp.ForeignKeyAction.noAction,
              onDelete: _isp.ForeignKeyAction.noAction,
              matchType: null,
            )
          ],
          indexes: [],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'reliability_report',
          dartName: 'ReliabilityReport',
          schema: 'public',
          module: 'incident_pulse',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'serviceId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'uptimePercent',
              columnType: _isp.ColumnType.doublePrecision,
              isNullable: false,
              dartType: 'double',
            ),
            _isp.ColumnDefinition(
              name: 'incidentCount',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'mttrMinutes',
              columnType: _isp.ColumnType.doublePrecision,
              isNullable: false,
              dartType: 'double',
            ),
            _isp.ColumnDefinition(
              name: 'healthScore',
              columnType: _isp.ColumnType.doublePrecision,
              isNullable: false,
              dartType: 'double',
            ),
            _isp.ColumnDefinition(
              name: 'reportSummary',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'generatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [
            _isp.ForeignKeyDefinition(
              constraintName: 'reliability_report_fk_0',
              columns: ['serviceId'],
              referenceTable: 'service',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: _isp.ForeignKeyAction.noAction,
              onDelete: _isp.ForeignKeyAction.noAction,
              matchType: null,
            )
          ],
          indexes: [],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'service',
          dartName: 'Service',
          schema: 'public',
          module: 'incident_pulse',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'name',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'slug',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'webhookKey',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'pingUrl',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'status',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'checkIntervalSeconds',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'lastPingAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
              dartType: 'DateTime?',
            ),
            _isp.ColumnDefinition(
              name: 'lastPingStatus',
              columnType: _isp.ColumnType.bigint,
              isNullable: true,
              dartType: 'int?',
            ),
            _isp.ColumnDefinition(
              name: 'isInternalOwner',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'enableAiBridge',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'dataRetentionDays',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'redactPii',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        ),
        ..._i1n3uhu0.Protocol.targetTableDefinitions,
        ..._isp.Protocol.targetTableDefinitions,
      ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iuema0oq.EscalationPolicy) {
      return _iuema0oq.EscalationPolicy.fromJson(data) as T;
    }
    if (t == _iy4wsyyx.Incident) {
      return _iy4wsyyx.Incident.fromJson(data) as T;
    }
    if (t == _icglyrab.IncidentEvent) {
      return _icglyrab.IncidentEvent.fromJson(data) as T;
    }
    if (t == _i48x74ln.ReliabilityReport) {
      return _i48x74ln.ReliabilityReport.fromJson(data) as T;
    }
    if (t == _i70zm44a.Service) {
      return _i70zm44a.Service.fromJson(data) as T;
    }
    if (t == _is.getType<_iuema0oq.EscalationPolicy?>()) {
      return (data != null ? _iuema0oq.EscalationPolicy.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iy4wsyyx.Incident?>()) {
      return (data != null ? _iy4wsyyx.Incident.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icglyrab.IncidentEvent?>()) {
      return (data != null ? _icglyrab.IncidentEvent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i48x74ln.ReliabilityReport?>()) {
      return (data != null ? _i48x74ln.ReliabilityReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i70zm44a.Service?>()) {
      return (data != null ? _i70zm44a.Service.fromJson(data) : null) as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == List<_ix5n0svs.Incident>) {
      return (data as List)
          .map((e) => deserialize<_ix5n0svs.Incident>(e))
          .toList() as T;
    }
    if (t == List<_i9u6usup.Service>) {
      return (data as List)
          .map((e) => deserialize<_i9u6usup.Service>(e))
          .toList() as T;
    }
    try {
      return _i1n3uhu0.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iuema0oq.EscalationPolicy => 'EscalationPolicy',
      _iy4wsyyx.Incident => 'Incident',
      _icglyrab.IncidentEvent => 'IncidentEvent',
      _i48x74ln.ReliabilityReport => 'ReliabilityReport',
      _i70zm44a.Service => 'Service',
      _ => null
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String)
          .replaceFirst('incident_pulse.', '');
    }

    switch (data) {
      case _iuema0oq.EscalationPolicy():
        return 'EscalationPolicy';
      case _iy4wsyyx.Incident():
        return 'Incident';
      case _icglyrab.IncidentEvent():
        return 'IncidentEvent';
      case _i48x74ln.ReliabilityReport():
        return 'ReliabilityReport';
      case _i70zm44a.Service():
        return 'Service';
    }
    className = _i1n3uhu0.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EscalationPolicy') {
      return deserialize<_iuema0oq.EscalationPolicy>(data['data']);
    }
    if (dataClassName == 'Incident') {
      return deserialize<_iy4wsyyx.Incident>(data['data']);
    }
    if (dataClassName == 'IncidentEvent') {
      return deserialize<_icglyrab.IncidentEvent>(data['data']);
    }
    if (dataClassName == 'ReliabilityReport') {
      return deserialize<_i48x74ln.ReliabilityReport>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i70zm44a.Service>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i1n3uhu0.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i1n3uhu0.Protocol().registerHostProtocol('incident_pulse', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _i1n3uhu0.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iuema0oq.EscalationPolicy:
        return _iuema0oq.EscalationPolicy.t;
      case _iy4wsyyx.Incident:
        return _iy4wsyyx.Incident.t;
      case _icglyrab.IncidentEvent:
        return _icglyrab.IncidentEvent.t;
      case _i48x74ln.ReliabilityReport:
        return _i48x74ln.ReliabilityReport.t;
      case _i70zm44a.Service:
        return _i70zm44a.Service.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'incident_pulse';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i1n3uhu0.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
