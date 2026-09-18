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

abstract class IncidentEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IncidentEvent._({
    this.id,
    required this.incidentId,
    required this.author,
    required this.eventType,
    required this.content,
    required this.isRedacted,
    required this.createdAt,
  });

  factory IncidentEvent({
    int? id,
    required int incidentId,
    required String author,
    required String eventType,
    required String content,
    required bool isRedacted,
    required DateTime createdAt,
  }) = _IncidentEventImpl;

  factory IncidentEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentEvent(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      author: jsonSerialization['author'] as String,
      eventType: jsonSerialization['eventType'] as String,
      content: jsonSerialization['content'] as String,
      isRedacted:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isRedacted']),
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int incidentId;

  String author;

  String eventType;

  String content;

  bool isRedacted;

  DateTime createdAt;

  /// Returns a shallow copy of this [IncidentEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IncidentEvent copyWith({
    int? id,
    int? incidentId,
    String? author,
    String? eventType,
    String? content,
    bool? isRedacted,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentEvent',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'author': author,
      'eventType': eventType,
      'content': content,
      'isRedacted': isRedacted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentEvent',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'author': author,
      'eventType': eventType,
      'content': content,
      'isRedacted': isRedacted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentEventImpl extends IncidentEvent {
  _IncidentEventImpl({
    int? id,
    required int incidentId,
    required String author,
    required String eventType,
    required String content,
    required bool isRedacted,
    required DateTime createdAt,
  }) : super._(
          id: id,
          incidentId: incidentId,
          author: author,
          eventType: eventType,
          content: content,
          isRedacted: isRedacted,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [IncidentEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IncidentEvent copyWith({
    Object? id = _Undefined,
    int? incidentId,
    String? author,
    String? eventType,
    String? content,
    bool? isRedacted,
    DateTime? createdAt,
  }) {
    return IncidentEvent(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      author: author ?? this.author,
      eventType: eventType ?? this.eventType,
      content: content ?? this.content,
      isRedacted: isRedacted ?? this.isRedacted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
