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

abstract class ReliabilityReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReliabilityReport._({
    this.id,
    required this.serviceId,
    required this.uptimePercent,
    required this.incidentCount,
    required this.mttrMinutes,
    required this.healthScore,
    required this.reportSummary,
    required this.generatedAt,
  });

  factory ReliabilityReport({
    int? id,
    required int serviceId,
    required double uptimePercent,
    required int incidentCount,
    required double mttrMinutes,
    required double healthScore,
    required String reportSummary,
    required DateTime generatedAt,
  }) = _ReliabilityReportImpl;

  factory ReliabilityReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReliabilityReport(
      id: jsonSerialization['id'] as int?,
      serviceId: jsonSerialization['serviceId'] as int,
      uptimePercent: (jsonSerialization['uptimePercent'] as num).toDouble(),
      incidentCount: jsonSerialization['incidentCount'] as int,
      mttrMinutes: (jsonSerialization['mttrMinutes'] as num).toDouble(),
      healthScore: (jsonSerialization['healthScore'] as num).toDouble(),
      reportSummary: jsonSerialization['reportSummary'] as String,
      generatedAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['generatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int serviceId;

  double uptimePercent;

  int incidentCount;

  double mttrMinutes;

  double healthScore;

  String reportSummary;

  DateTime generatedAt;

  /// Returns a shallow copy of this [ReliabilityReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReliabilityReport copyWith({
    int? id,
    int? serviceId,
    double? uptimePercent,
    int? incidentCount,
    double? mttrMinutes,
    double? healthScore,
    String? reportSummary,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReliabilityReport',
      if (id != null) 'id': id,
      'serviceId': serviceId,
      'uptimePercent': uptimePercent,
      'incidentCount': incidentCount,
      'mttrMinutes': mttrMinutes,
      'healthScore': healthScore,
      'reportSummary': reportSummary,
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReliabilityReport',
      if (id != null) 'id': id,
      'serviceId': serviceId,
      'uptimePercent': uptimePercent,
      'incidentCount': incidentCount,
      'mttrMinutes': mttrMinutes,
      'healthScore': healthScore,
      'reportSummary': reportSummary,
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReliabilityReportImpl extends ReliabilityReport {
  _ReliabilityReportImpl({
    int? id,
    required int serviceId,
    required double uptimePercent,
    required int incidentCount,
    required double mttrMinutes,
    required double healthScore,
    required String reportSummary,
    required DateTime generatedAt,
  }) : super._(
          id: id,
          serviceId: serviceId,
          uptimePercent: uptimePercent,
          incidentCount: incidentCount,
          mttrMinutes: mttrMinutes,
          healthScore: healthScore,
          reportSummary: reportSummary,
          generatedAt: generatedAt,
        );

  /// Returns a shallow copy of this [ReliabilityReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReliabilityReport copyWith({
    Object? id = _Undefined,
    int? serviceId,
    double? uptimePercent,
    int? incidentCount,
    double? mttrMinutes,
    double? healthScore,
    String? reportSummary,
    DateTime? generatedAt,
  }) {
    return ReliabilityReport(
      id: id is int? ? id : this.id,
      serviceId: serviceId ?? this.serviceId,
      uptimePercent: uptimePercent ?? this.uptimePercent,
      incidentCount: incidentCount ?? this.incidentCount,
      mttrMinutes: mttrMinutes ?? this.mttrMinutes,
      healthScore: healthScore ?? this.healthScore,
      reportSummary: reportSummary ?? this.reportSummary,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
