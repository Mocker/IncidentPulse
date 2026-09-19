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
import 'package:incident_pulse_client/src/protocol/incident.dart' as _ii2a5p2r;
import 'package:incident_pulse_client/src/protocol/service.dart' as _icu7ot0t;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
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
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _isc.getType<_iuema0oq.EscalationPolicy?>()) {
      return (data != null ? _iuema0oq.EscalationPolicy.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iy4wsyyx.Incident?>()) {
      return (data != null ? _iy4wsyyx.Incident.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icglyrab.IncidentEvent?>()) {
      return (data != null ? _icglyrab.IncidentEvent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i48x74ln.ReliabilityReport?>()) {
      return (data != null ? _i48x74ln.ReliabilityReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i70zm44a.Service?>()) {
      return (data != null ? _i70zm44a.Service.fromJson(data) : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == List<_ii2a5p2r.Incident>) {
      return (data as List)
          .map((e) => deserialize<_ii2a5p2r.Incident>(e))
          .toList() as T;
    }
    if (t == List<_icu7ot0t.Service>) {
      return (data as List)
          .map((e) => deserialize<_icu7ot0t.Service>(e))
          .toList() as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as T;
    }
    try {
      return _i312scxx.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
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
    className = _i312scxx.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
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
      return _i312scxx.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i312scxx.Protocol().registerHostProtocol('incident_pulse', this);
  }

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
      return _i312scxx.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
