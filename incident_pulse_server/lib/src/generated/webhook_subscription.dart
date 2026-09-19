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
import 'package:incident_pulse_server/src/generated/protocol.dart' as _iniyokuh;
import 'package:serverpod/serverpod.dart' as _is;

abstract class WebhookSubscription
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _iniyokuh.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['customHeaders']),
      events: _iniyokuh.Protocol()
          .deserialize<List<String>>(jsonSerialization['events']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = WebhookSubscriptionTable();

  static const db = WebhookSubscriptionRepository._();

  @override
  int? id;

  int? serviceId;

  String name;

  String targetUrl;

  String? secretKey;

  Map<String, String>? customHeaders;

  List<String> events;

  bool isActive;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WebhookSubscription]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static WebhookSubscriptionInclude include() {
    return WebhookSubscriptionInclude._();
  }

  static WebhookSubscriptionIncludeList includeList({
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WebhookSubscriptionTable>? orderBy,
    _is.OrderByListBuilder<WebhookSubscriptionTable>? orderByList,
    WebhookSubscriptionInclude? include,
  }) {
    return WebhookSubscriptionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WebhookSubscription.t),
      orderByList: orderByList?.call(WebhookSubscription.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class WebhookSubscriptionUpdateTable
    extends _is.UpdateTable<WebhookSubscriptionTable> {
  WebhookSubscriptionUpdateTable(super.table);

  _is.ColumnValue<int, int> serviceId(int? value) => _is.ColumnValue(
        table.serviceId,
        value,
      );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
        table.name,
        value,
      );

  _is.ColumnValue<String, String> targetUrl(String value) => _is.ColumnValue(
        table.targetUrl,
        value,
      );

  _is.ColumnValue<String, String> secretKey(String? value) => _is.ColumnValue(
        table.secretKey,
        value,
      );

  _is.ColumnValue<Map<String, String>, Map<String, String>> customHeaders(
          Map<String, String>? value) =>
      _is.ColumnValue(
        table.customHeaders,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> events(List<String> value) =>
      _is.ColumnValue(
        table.events,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
        table.isActive,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class WebhookSubscriptionTable extends _is.Table<int?> {
  WebhookSubscriptionTable({super.tableRelation})
      : super(tableName: 'webhook_subscription') {
    updateTable = WebhookSubscriptionUpdateTable(this);
    serviceId = _is.ColumnInt(
      'serviceId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    targetUrl = _is.ColumnString(
      'targetUrl',
      this,
    );
    secretKey = _is.ColumnString(
      'secretKey',
      this,
    );
    customHeaders = _is.ColumnSerializable<Map<String, String>>(
      'customHeaders',
      this,
    );
    events = _is.ColumnSerializable<List<String>>(
      'events',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final WebhookSubscriptionUpdateTable updateTable;

  late final _is.ColumnInt serviceId;

  late final _is.ColumnString name;

  late final _is.ColumnString targetUrl;

  late final _is.ColumnString secretKey;

  late final _is.ColumnSerializable<Map<String, String>> customHeaders;

  late final _is.ColumnSerializable<List<String>> events;

  late final _is.ColumnBool isActive;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
        id,
        serviceId,
        name,
        targetUrl,
        secretKey,
        customHeaders,
        events,
        isActive,
        createdAt,
      ];
}

class WebhookSubscriptionInclude extends _is.IncludeObject {
  WebhookSubscriptionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => WebhookSubscription.t;
}

class WebhookSubscriptionIncludeList extends _is.IncludeList {
  WebhookSubscriptionIncludeList._({
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WebhookSubscription.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WebhookSubscription.t;
}

class WebhookSubscriptionRepository {
  const WebhookSubscriptionRepository._();

  /// Returns a list of [WebhookSubscription]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<WebhookSubscription>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WebhookSubscriptionTable>? orderBy,
    _is.OrderByListBuilder<WebhookSubscriptionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WebhookSubscription>(
      where: where?.call(WebhookSubscription.t),
      orderBy: orderBy?.call(WebhookSubscription.t),
      orderByList: orderByList?.call(WebhookSubscription.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WebhookSubscription] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<WebhookSubscription?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? where,
    int? offset,
    _is.OrderByBuilder<WebhookSubscriptionTable>? orderBy,
    _is.OrderByListBuilder<WebhookSubscriptionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WebhookSubscription>(
      where: where?.call(WebhookSubscription.t),
      orderBy: orderBy?.call(WebhookSubscription.t),
      orderByList: orderByList?.call(WebhookSubscription.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WebhookSubscription] by its [id] or null if no such row exists.
  Future<WebhookSubscription?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WebhookSubscription>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WebhookSubscription]s in the list and returns the inserted rows.
  ///
  /// The returned [WebhookSubscription]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookSubscription>> insert(
    _is.DatabaseSession session,
    List<WebhookSubscription> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WebhookSubscription>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WebhookSubscription] and returns the inserted row.
  ///
  /// The returned [WebhookSubscription] will have its `id` field set.
  Future<WebhookSubscription> insertRow(
    _is.DatabaseSession session,
    WebhookSubscription row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WebhookSubscription>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WebhookSubscription]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [WebhookSubscription]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookSubscription>> upsert(
    _is.DatabaseSession session,
    List<WebhookSubscription> rows, {
    required _is.ColumnSelections<WebhookSubscriptionTable> conflictColumns,
    _is.ColumnSelections<WebhookSubscriptionTable>? updateColumns,
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WebhookSubscription>(
      rows,
      conflictColumns: conflictColumns(WebhookSubscription.t),
      updateColumns: updateColumns?.call(WebhookSubscription.t),
      updateWhere: updateWhere?.call(WebhookSubscription.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WebhookSubscription] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [WebhookSubscription] will have its `id` field set.
  Future<WebhookSubscription?> upsertRow(
    _is.DatabaseSession session,
    WebhookSubscription row, {
    required _is.ColumnSelections<WebhookSubscriptionTable> conflictColumns,
    _is.ColumnSelections<WebhookSubscriptionTable>? updateColumns,
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WebhookSubscription>(
      row,
      conflictColumns: conflictColumns(WebhookSubscription.t),
      updateColumns: updateColumns?.call(WebhookSubscription.t),
      updateWhere: updateWhere?.call(WebhookSubscription.t),
      transaction: transaction,
    );
  }

  /// Updates all [WebhookSubscription]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookSubscription>> update(
    _is.DatabaseSession session,
    List<WebhookSubscription> rows, {
    _is.ColumnSelections<WebhookSubscriptionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WebhookSubscription>(
      rows,
      columns: columns?.call(WebhookSubscription.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WebhookSubscription]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WebhookSubscription> updateRow(
    _is.DatabaseSession session,
    WebhookSubscription row, {
    _is.ColumnSelections<WebhookSubscriptionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WebhookSubscription>(
      row,
      columns: columns?.call(WebhookSubscription.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WebhookSubscription] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WebhookSubscription?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WebhookSubscriptionUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WebhookSubscription>(
      id,
      columnValues: columnValues(WebhookSubscription.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WebhookSubscription]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookSubscription>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WebhookSubscriptionUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<WebhookSubscriptionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WebhookSubscriptionTable>? orderBy,
    _is.OrderByListBuilder<WebhookSubscriptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WebhookSubscription>(
      columnValues: columnValues(WebhookSubscription.t.updateTable),
      where: where(WebhookSubscription.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WebhookSubscription.t),
      orderByList: orderByList?.call(WebhookSubscription.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WebhookSubscription]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookSubscription>> delete(
    _is.DatabaseSession session,
    List<WebhookSubscription> rows, {
    _is.OrderByBuilder<WebhookSubscriptionTable>? orderBy,
    _is.OrderByListBuilder<WebhookSubscriptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WebhookSubscription>(
      rows,
      orderBy: orderBy?.call(WebhookSubscription.t),
      orderByList: orderByList?.call(WebhookSubscription.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WebhookSubscription].
  Future<WebhookSubscription> deleteRow(
    _is.DatabaseSession session,
    WebhookSubscription row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WebhookSubscription>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WebhookSubscription>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WebhookSubscriptionTable> where,
    _is.OrderByBuilder<WebhookSubscriptionTable>? orderBy,
    _is.OrderByListBuilder<WebhookSubscriptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WebhookSubscription>(
      where: where(WebhookSubscription.t),
      orderBy: orderBy?.call(WebhookSubscription.t),
      orderByList: orderByList?.call(WebhookSubscription.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WebhookSubscriptionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WebhookSubscription>(
      where: where?.call(WebhookSubscription.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WebhookSubscription] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WebhookSubscriptionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WebhookSubscription>(
      where: where(WebhookSubscription.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
