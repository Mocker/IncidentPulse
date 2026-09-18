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

abstract class EscalationPolicy
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EscalationPolicy._({
    this.id,
    required this.serviceId,
    required this.timeoutMinutes,
    this.notifyEmail,
    this.notifyWebhookUrl,
    required this.isActive,
  });

  factory EscalationPolicy({
    int? id,
    required int serviceId,
    required int timeoutMinutes,
    String? notifyEmail,
    String? notifyWebhookUrl,
    required bool isActive,
  }) = _EscalationPolicyImpl;

  factory EscalationPolicy.fromJson(Map<String, dynamic> jsonSerialization) {
    return EscalationPolicy(
      id: jsonSerialization['id'] as int?,
      serviceId: jsonSerialization['serviceId'] as int,
      timeoutMinutes: jsonSerialization['timeoutMinutes'] as int,
      notifyEmail: jsonSerialization['notifyEmail'] as String?,
      notifyWebhookUrl: jsonSerialization['notifyWebhookUrl'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int serviceId;

  int timeoutMinutes;

  String? notifyEmail;

  String? notifyWebhookUrl;

  bool isActive;

  /// Returns a shallow copy of this [EscalationPolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EscalationPolicy copyWith({
    int? id,
    int? serviceId,
    int? timeoutMinutes,
    String? notifyEmail,
    String? notifyWebhookUrl,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EscalationPolicy',
      if (id != null) 'id': id,
      'serviceId': serviceId,
      'timeoutMinutes': timeoutMinutes,
      if (notifyEmail != null) 'notifyEmail': notifyEmail,
      if (notifyWebhookUrl != null) 'notifyWebhookUrl': notifyWebhookUrl,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EscalationPolicy',
      if (id != null) 'id': id,
      'serviceId': serviceId,
      'timeoutMinutes': timeoutMinutes,
      if (notifyEmail != null) 'notifyEmail': notifyEmail,
      if (notifyWebhookUrl != null) 'notifyWebhookUrl': notifyWebhookUrl,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EscalationPolicyImpl extends EscalationPolicy {
  _EscalationPolicyImpl({
    int? id,
    required int serviceId,
    required int timeoutMinutes,
    String? notifyEmail,
    String? notifyWebhookUrl,
    required bool isActive,
  }) : super._(
          id: id,
          serviceId: serviceId,
          timeoutMinutes: timeoutMinutes,
          notifyEmail: notifyEmail,
          notifyWebhookUrl: notifyWebhookUrl,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [EscalationPolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EscalationPolicy copyWith({
    Object? id = _Undefined,
    int? serviceId,
    int? timeoutMinutes,
    Object? notifyEmail = _Undefined,
    Object? notifyWebhookUrl = _Undefined,
    bool? isActive,
  }) {
    return EscalationPolicy(
      id: id is int? ? id : this.id,
      serviceId: serviceId ?? this.serviceId,
      timeoutMinutes: timeoutMinutes ?? this.timeoutMinutes,
      notifyEmail: notifyEmail is String? ? notifyEmail : this.notifyEmail,
      notifyWebhookUrl: notifyWebhookUrl is String?
          ? notifyWebhookUrl
          : this.notifyWebhookUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
