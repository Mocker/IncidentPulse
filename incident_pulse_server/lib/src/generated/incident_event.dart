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
import 'package:serverpod/serverpod.dart' as _is;

abstract class IncidentEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          _is.BoolJsonExtension.fromJson(jsonSerialization['isRedacted']),
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = IncidentEventTable();

  static const db = IncidentEventRepository._();

  @override
  int? id;

  int incidentId;

  String author;

  String eventType;

  String content;

  bool isRedacted;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IncidentEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static IncidentEventInclude include() {
    return IncidentEventInclude._();
  }

  static IncidentEventIncludeList includeList({
    _is.WhereExpressionBuilder<IncidentEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentEventTable>? orderBy,
    _is.OrderByListBuilder<IncidentEventTable>? orderByList,
    IncidentEventInclude? include,
  }) {
    return IncidentEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IncidentEvent.t),
      orderByList: orderByList?.call(IncidentEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class IncidentEventUpdateTable extends _is.UpdateTable<IncidentEventTable> {
  IncidentEventUpdateTable(super.table);

  _is.ColumnValue<int, int> incidentId(int value) => _is.ColumnValue(
        table.incidentId,
        value,
      );

  _is.ColumnValue<String, String> author(String value) => _is.ColumnValue(
        table.author,
        value,
      );

  _is.ColumnValue<String, String> eventType(String value) => _is.ColumnValue(
        table.eventType,
        value,
      );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
        table.content,
        value,
      );

  _is.ColumnValue<bool, bool> isRedacted(bool value) => _is.ColumnValue(
        table.isRedacted,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class IncidentEventTable extends _is.Table<int?> {
  IncidentEventTable({super.tableRelation})
      : super(tableName: 'incident_event') {
    updateTable = IncidentEventUpdateTable(this);
    incidentId = _is.ColumnInt(
      'incidentId',
      this,
    );
    author = _is.ColumnString(
      'author',
      this,
    );
    eventType = _is.ColumnString(
      'eventType',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    isRedacted = _is.ColumnBool(
      'isRedacted',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final IncidentEventUpdateTable updateTable;

  late final _is.ColumnInt incidentId;

  late final _is.ColumnString author;

  late final _is.ColumnString eventType;

  late final _is.ColumnString content;

  late final _is.ColumnBool isRedacted;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
        id,
        incidentId,
        author,
        eventType,
        content,
        isRedacted,
        createdAt,
      ];
}

class IncidentEventInclude extends _is.IncludeObject {
  IncidentEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IncidentEvent.t;
}

class IncidentEventIncludeList extends _is.IncludeList {
  IncidentEventIncludeList._({
    _is.WhereExpressionBuilder<IncidentEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IncidentEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IncidentEvent.t;
}

class IncidentEventRepository {
  const IncidentEventRepository._();

  /// Returns a list of [IncidentEvent]s matching the given query parameters.
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
  Future<List<IncidentEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentEventTable>? orderBy,
    _is.OrderByListBuilder<IncidentEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IncidentEvent>(
      where: where?.call(IncidentEvent.t),
      orderBy: orderBy?.call(IncidentEvent.t),
      orderByList: orderByList?.call(IncidentEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IncidentEvent] matching the given query parameters.
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
  Future<IncidentEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentEventTable>? where,
    int? offset,
    _is.OrderByBuilder<IncidentEventTable>? orderBy,
    _is.OrderByListBuilder<IncidentEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IncidentEvent>(
      where: where?.call(IncidentEvent.t),
      orderBy: orderBy?.call(IncidentEvent.t),
      orderByList: orderByList?.call(IncidentEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IncidentEvent] by its [id] or null if no such row exists.
  Future<IncidentEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IncidentEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IncidentEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [IncidentEvent]s will have their `id` fields set.
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
  Future<List<IncidentEvent>> insert(
    _is.DatabaseSession session,
    List<IncidentEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IncidentEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IncidentEvent] and returns the inserted row.
  ///
  /// The returned [IncidentEvent] will have its `id` field set.
  Future<IncidentEvent> insertRow(
    _is.DatabaseSession session,
    IncidentEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IncidentEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IncidentEvent]s in the list and returns the resulting rows.
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
  /// The returned [IncidentEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IncidentEvent>> upsert(
    _is.DatabaseSession session,
    List<IncidentEvent> rows, {
    required _is.ColumnSelections<IncidentEventTable> conflictColumns,
    _is.ColumnSelections<IncidentEventTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IncidentEvent>(
      rows,
      conflictColumns: conflictColumns(IncidentEvent.t),
      updateColumns: updateColumns?.call(IncidentEvent.t),
      updateWhere: updateWhere?.call(IncidentEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IncidentEvent] and returns the resulting row.
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
  /// The returned [IncidentEvent] will have its `id` field set.
  Future<IncidentEvent?> upsertRow(
    _is.DatabaseSession session,
    IncidentEvent row, {
    required _is.ColumnSelections<IncidentEventTable> conflictColumns,
    _is.ColumnSelections<IncidentEventTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IncidentEvent>(
      row,
      conflictColumns: conflictColumns(IncidentEvent.t),
      updateColumns: updateColumns?.call(IncidentEvent.t),
      updateWhere: updateWhere?.call(IncidentEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [IncidentEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IncidentEvent>> update(
    _is.DatabaseSession session,
    List<IncidentEvent> rows, {
    _is.ColumnSelections<IncidentEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IncidentEvent>(
      rows,
      columns: columns?.call(IncidentEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IncidentEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IncidentEvent> updateRow(
    _is.DatabaseSession session,
    IncidentEvent row, {
    _is.ColumnSelections<IncidentEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IncidentEvent>(
      row,
      columns: columns?.call(IncidentEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IncidentEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IncidentEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IncidentEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IncidentEvent>(
      id,
      columnValues: columnValues(IncidentEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IncidentEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IncidentEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IncidentEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<IncidentEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentEventTable>? orderBy,
    _is.OrderByListBuilder<IncidentEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IncidentEvent>(
      columnValues: columnValues(IncidentEvent.t.updateTable),
      where: where(IncidentEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IncidentEvent.t),
      orderByList: orderByList?.call(IncidentEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IncidentEvent]s in the list and returns the deleted rows.
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
  Future<List<IncidentEvent>> delete(
    _is.DatabaseSession session,
    List<IncidentEvent> rows, {
    _is.OrderByBuilder<IncidentEventTable>? orderBy,
    _is.OrderByListBuilder<IncidentEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IncidentEvent>(
      rows,
      orderBy: orderBy?.call(IncidentEvent.t),
      orderByList: orderByList?.call(IncidentEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IncidentEvent].
  Future<IncidentEvent> deleteRow(
    _is.DatabaseSession session,
    IncidentEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IncidentEvent>(
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
  Future<List<IncidentEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentEventTable> where,
    _is.OrderByBuilder<IncidentEventTable>? orderBy,
    _is.OrderByListBuilder<IncidentEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IncidentEvent>(
      where: where(IncidentEvent.t),
      orderBy: orderBy?.call(IncidentEvent.t),
      orderByList: orderByList?.call(IncidentEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IncidentEvent>(
      where: where?.call(IncidentEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IncidentEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IncidentEvent>(
      where: where(IncidentEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
