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

abstract class Service
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Service._({
    this.id,
    required this.name,
    required this.slug,
    required this.webhookKey,
    this.pingUrl,
    required this.status,
    required this.checkIntervalSeconds,
    this.lastPingAt,
    this.lastPingStatus,
    required this.isInternalOwner,
    required this.enableAiBridge,
    required this.dataRetentionDays,
    required this.redactPii,
    required this.createdAt,
  });

  factory Service({
    int? id,
    required String name,
    required String slug,
    required String webhookKey,
    String? pingUrl,
    required String status,
    required int checkIntervalSeconds,
    DateTime? lastPingAt,
    int? lastPingStatus,
    required bool isInternalOwner,
    required bool enableAiBridge,
    required int dataRetentionDays,
    required bool redactPii,
    required DateTime createdAt,
  }) = _ServiceImpl;

  factory Service.fromJson(Map<String, dynamic> jsonSerialization) {
    return Service(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      webhookKey: jsonSerialization['webhookKey'] as String,
      pingUrl: jsonSerialization['pingUrl'] as String?,
      status: jsonSerialization['status'] as String,
      checkIntervalSeconds: jsonSerialization['checkIntervalSeconds'] as int,
      lastPingAt: jsonSerialization['lastPingAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPingAt']),
      lastPingStatus: jsonSerialization['lastPingStatus'] as int?,
      isInternalOwner:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isInternalOwner']),
      enableAiBridge:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['enableAiBridge']),
      dataRetentionDays: jsonSerialization['dataRetentionDays'] as int,
      redactPii:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['redactPii']),
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String slug;

  String webhookKey;

  String? pingUrl;

  String status;

  int checkIntervalSeconds;

  DateTime? lastPingAt;

  int? lastPingStatus;

  bool isInternalOwner;

  bool enableAiBridge;

  int dataRetentionDays;

  bool redactPii;

  DateTime createdAt;

  /// Returns a shallow copy of this [Service]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Service copyWith({
    int? id,
    String? name,
    String? slug,
    String? webhookKey,
    String? pingUrl,
    String? status,
    int? checkIntervalSeconds,
    DateTime? lastPingAt,
    int? lastPingStatus,
    bool? isInternalOwner,
    bool? enableAiBridge,
    int? dataRetentionDays,
    bool? redactPii,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Service',
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      'webhookKey': webhookKey,
      if (pingUrl != null) 'pingUrl': pingUrl,
      'status': status,
      'checkIntervalSeconds': checkIntervalSeconds,
      if (lastPingAt != null) 'lastPingAt': lastPingAt?.toJson(),
      if (lastPingStatus != null) 'lastPingStatus': lastPingStatus,
      'isInternalOwner': isInternalOwner,
      'enableAiBridge': enableAiBridge,
      'dataRetentionDays': dataRetentionDays,
      'redactPii': redactPii,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Service',
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      'webhookKey': webhookKey,
      if (pingUrl != null) 'pingUrl': pingUrl,
      'status': status,
      'checkIntervalSeconds': checkIntervalSeconds,
      if (lastPingAt != null) 'lastPingAt': lastPingAt?.toJson(),
      if (lastPingStatus != null) 'lastPingStatus': lastPingStatus,
      'isInternalOwner': isInternalOwner,
      'enableAiBridge': enableAiBridge,
      'dataRetentionDays': dataRetentionDays,
      'redactPii': redactPii,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceImpl extends Service {
  _ServiceImpl({
    int? id,
    required String name,
    required String slug,
    required String webhookKey,
    String? pingUrl,
    required String status,
    required int checkIntervalSeconds,
    DateTime? lastPingAt,
    int? lastPingStatus,
    required bool isInternalOwner,
    required bool enableAiBridge,
    required int dataRetentionDays,
    required bool redactPii,
    required DateTime createdAt,
  }) : super._(
          id: id,
          name: name,
          slug: slug,
          webhookKey: webhookKey,
          pingUrl: pingUrl,
          status: status,
          checkIntervalSeconds: checkIntervalSeconds,
          lastPingAt: lastPingAt,
          lastPingStatus: lastPingStatus,
          isInternalOwner: isInternalOwner,
          enableAiBridge: enableAiBridge,
          dataRetentionDays: dataRetentionDays,
          redactPii: redactPii,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Service]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Service copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    String? webhookKey,
    Object? pingUrl = _Undefined,
    String? status,
    int? checkIntervalSeconds,
    Object? lastPingAt = _Undefined,
    Object? lastPingStatus = _Undefined,
    bool? isInternalOwner,
    bool? enableAiBridge,
    int? dataRetentionDays,
    bool? redactPii,
    DateTime? createdAt,
  }) {
    return Service(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      webhookKey: webhookKey ?? this.webhookKey,
      pingUrl: pingUrl is String? ? pingUrl : this.pingUrl,
      status: status ?? this.status,
      checkIntervalSeconds: checkIntervalSeconds ?? this.checkIntervalSeconds,
      lastPingAt: lastPingAt is DateTime? ? lastPingAt : this.lastPingAt,
      lastPingStatus:
          lastPingStatus is int? ? lastPingStatus : this.lastPingStatus,
      isInternalOwner: isInternalOwner ?? this.isInternalOwner,
      enableAiBridge: enableAiBridge ?? this.enableAiBridge,
      dataRetentionDays: dataRetentionDays ?? this.dataRetentionDays,
      redactPii: redactPii ?? this.redactPii,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
