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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Incident
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Incident._({
    this.id,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.source,
    this.rootCause,
    this.rawPayload,
    required this.isRedacted,
    this.expiresAt,
    required this.triggeredAt,
    this.acknowledgedAt,
    this.resolvedAt,
  });

  factory Incident({
    int? id,
    required int serviceId,
    required String title,
    required String description,
    required String severity,
    required String status,
    required String source,
    String? rootCause,
    String? rawPayload,
    required bool isRedacted,
    DateTime? expiresAt,
    required DateTime triggeredAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
  }) = _IncidentImpl;

  factory Incident.fromJson(Map<String, dynamic> jsonSerialization) {
    return Incident(
      id: jsonSerialization['id'] as int?,
      serviceId: jsonSerialization['serviceId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      severity: jsonSerialization['severity'] as String,
      status: jsonSerialization['status'] as String,
      source: jsonSerialization['source'] as String,
      rootCause: jsonSerialization['rootCause'] as String?,
      rawPayload: jsonSerialization['rawPayload'] as String?,
      isRedacted:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isRedacted']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      triggeredAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['triggeredAt']),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int serviceId;

  String title;

  String description;

  String severity;

  String status;

  String source;

  String? rootCause;

  String? rawPayload;

  bool isRedacted;

  DateTime? expiresAt;

  DateTime triggeredAt;

  DateTime? acknowledgedAt;

  DateTime? resolvedAt;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Incident copyWith({
    int? id,
    int? serviceId,
    String? title,
    String? description,
    String? severity,
    String? status,
    String? source,
    String? rootCause,
    String? rawPayload,
    bool? isRedacted,
    DateTime? expiresAt,
    DateTime? triggeredAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'serviceId': serviceId,
      'title': title,
      'description': description,
      'severity': severity,
      'status': status,
      'source': source,
      if (rootCause != null) 'rootCause': rootCause,
      if (rawPayload != null) 'rawPayload': rawPayload,
      'isRedacted': isRedacted,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'triggeredAt': triggeredAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'serviceId': serviceId,
      'title': title,
      'description': description,
      'severity': severity,
      'status': status,
      'source': source,
      if (rootCause != null) 'rootCause': rootCause,
      if (rawPayload != null) 'rawPayload': rawPayload,
      'isRedacted': isRedacted,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'triggeredAt': triggeredAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentImpl extends Incident {
  _IncidentImpl({
    int? id,
    required int serviceId,
    required String title,
    required String description,
    required String severity,
    required String status,
    required String source,
    String? rootCause,
    String? rawPayload,
    required bool isRedacted,
    DateTime? expiresAt,
    required DateTime triggeredAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
  }) : super._(
          id: id,
          serviceId: serviceId,
          title: title,
          description: description,
          severity: severity,
          status: status,
          source: source,
          rootCause: rootCause,
          rawPayload: rawPayload,
          isRedacted: isRedacted,
          expiresAt: expiresAt,
          triggeredAt: triggeredAt,
          acknowledgedAt: acknowledgedAt,
          resolvedAt: resolvedAt,
        );

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Incident copyWith({
    Object? id = _Undefined,
    int? serviceId,
    String? title,
    String? description,
    String? severity,
    String? status,
    String? source,
    Object? rootCause = _Undefined,
    Object? rawPayload = _Undefined,
    bool? isRedacted,
    Object? expiresAt = _Undefined,
    DateTime? triggeredAt,
    Object? acknowledgedAt = _Undefined,
    Object? resolvedAt = _Undefined,
  }) {
    return Incident(
      id: id is int? ? id : this.id,
      serviceId: serviceId ?? this.serviceId,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      source: source ?? this.source,
      rootCause: rootCause is String? ? rootCause : this.rootCause,
      rawPayload: rawPayload is String? ? rawPayload : this.rawPayload,
      isRedacted: isRedacted ?? this.isRedacted,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      acknowledgedAt:
          acknowledgedAt is DateTime? ? acknowledgedAt : this.acknowledgedAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}
