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
import 'package:incident_pulse_client/src/protocol/protocol.dart' as _i7ndyoko;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class WebhookSubscription
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WebhookSubscription._({
    this.id,
    this.serviceId,
    required this.name,
    required this.targetUrl,
    this.secretKey,
    this.customHeaders,
    required this.events,
    required this.isActive,
    required this.createdAt,
  });

  factory WebhookSubscription({
    int? id,
    int? serviceId,
    required String name,
    required String targetUrl,
    String? secretKey,
    Map<String, String>? customHeaders,
    required List<String> events,
    required bool isActive,
    required DateTime createdAt,
  }) = _WebhookSubscriptionImpl;

  factory WebhookSubscription.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookSubscription(
      id: jsonSerialization['id'] as int?,
      serviceId: jsonSerialization['serviceId'] as int?,
      name: jsonSerialization['name'] as String,
      targetUrl: jsonSerialization['targetUrl'] as String,
      secretKey: jsonSerialization['secretKey'] as String?,
      customHeaders: jsonSerialization['customHeaders'] == null
          ? null
          : _i7ndyoko.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['customHeaders']),
      events: _i7ndyoko.Protocol()
          .deserialize<List<String>>(jsonSerialization['events']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? serviceId;

  String name;

  String targetUrl;

  String? secretKey;

  Map<String, String>? customHeaders;

  List<String> events;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [WebhookSubscription]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WebhookSubscription copyWith({
    int? id,
    int? serviceId,
    String? name,
    String? targetUrl,
    String? secretKey,
    Map<String, String>? customHeaders,
    List<String>? events,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookSubscription',
      if (id != null) 'id': id,
      if (serviceId != null) 'serviceId': serviceId,
      'name': name,
      'targetUrl': targetUrl,
      if (secretKey != null) 'secretKey': secretKey,
      if (customHeaders != null) 'customHeaders': customHeaders?.toJson(),
      'events': events.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookSubscription',
      if (id != null) 'id': id,
      if (serviceId != null) 'serviceId': serviceId,
      'name': name,
      'targetUrl': targetUrl,
      if (secretKey != null) 'secretKey': secretKey,
      if (customHeaders != null) 'customHeaders': customHeaders?.toJson(),
      'events': events.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookSubscriptionImpl extends WebhookSubscription {
  _WebhookSubscriptionImpl({
    int? id,
    int? serviceId,
    required String name,
    required String targetUrl,
    String? secretKey,
    Map<String, String>? customHeaders,
    required List<String> events,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
          id: id,
          serviceId: serviceId,
          name: name,
          targetUrl: targetUrl,
          secretKey: secretKey,
          customHeaders: customHeaders,
          events: events,
          isActive: isActive,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [WebhookSubscription]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WebhookSubscription copyWith({
    Object? id = _Undefined,
    Object? serviceId = _Undefined,
    String? name,
    String? targetUrl,
    Object? secretKey = _Undefined,
    Object? customHeaders = _Undefined,
    List<String>? events,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return WebhookSubscription(
      id: id is int? ? id : this.id,
      serviceId: serviceId is int? ? serviceId : this.serviceId,
      name: name ?? this.name,
      targetUrl: targetUrl ?? this.targetUrl,
      secretKey: secretKey is String? ? secretKey : this.secretKey,
      customHeaders: customHeaders is Map<String, String>?
          ? customHeaders
          : this.customHeaders?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      events: events ?? this.events.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
