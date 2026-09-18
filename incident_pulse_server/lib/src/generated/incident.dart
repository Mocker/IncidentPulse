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

abstract class Incident
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          _is.BoolJsonExtension.fromJson(jsonSerialization['isRedacted']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      triggeredAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['triggeredAt']),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
    );
  }

  static final t = IncidentTable();

  static const db = IncidentRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static IncidentInclude include() {
    return IncidentInclude._();
  }

  static IncidentIncludeList includeList({
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    IncidentInclude? include,
  }) {
    return IncidentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class IncidentUpdateTable extends _is.UpdateTable<IncidentTable> {
  IncidentUpdateTable(super.table);

  _is.ColumnValue<int, int> serviceId(int value) => _is.ColumnValue(
        table.serviceId,
        value,
      );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
        table.title,
        value,
      );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
        table.description,
        value,
      );

  _is.ColumnValue<String, String> severity(String value) => _is.ColumnValue(
        table.severity,
        value,
      );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
        table.status,
        value,
      );

  _is.ColumnValue<String, String> source(String value) => _is.ColumnValue(
        table.source,
        value,
      );

  _is.ColumnValue<String, String> rootCause(String? value) => _is.ColumnValue(
        table.rootCause,
        value,
      );

  _is.ColumnValue<String, String> rawPayload(String? value) => _is.ColumnValue(
        table.rawPayload,
        value,
      );

  _is.ColumnValue<bool, bool> isRedacted(bool value) => _is.ColumnValue(
        table.isRedacted,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> triggeredAt(DateTime value) =>
      _is.ColumnValue(
        table.triggeredAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> acknowledgedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acknowledgedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );
}

class IncidentTable extends _is.Table<int?> {
  IncidentTable({super.tableRelation}) : super(tableName: 'incident') {
    updateTable = IncidentUpdateTable(this);
    serviceId = _is.ColumnInt(
      'serviceId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    severity = _is.ColumnString(
      'severity',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    source = _is.ColumnString(
      'source',
      this,
    );
    rootCause = _is.ColumnString(
      'rootCause',
      this,
    );
    rawPayload = _is.ColumnString(
      'rawPayload',
      this,
    );
    isRedacted = _is.ColumnBool(
      'isRedacted',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    triggeredAt = _is.ColumnDateTime(
      'triggeredAt',
      this,
    );
    acknowledgedAt = _is.ColumnDateTime(
      'acknowledgedAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
  }

  late final IncidentUpdateTable updateTable;

  late final _is.ColumnInt serviceId;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString severity;

  late final _is.ColumnString status;

  late final _is.ColumnString source;

  late final _is.ColumnString rootCause;

  late final _is.ColumnString rawPayload;

  late final _is.ColumnBool isRedacted;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime triggeredAt;

  late final _is.ColumnDateTime acknowledgedAt;

  late final _is.ColumnDateTime resolvedAt;

  @override
  List<_is.Column> get columns => [
        id,
        serviceId,
        title,
        description,
        severity,
        status,
        source,
        rootCause,
        rawPayload,
        isRedacted,
        expiresAt,
        triggeredAt,
        acknowledgedAt,
        resolvedAt,
      ];
}

class IncidentInclude extends _is.IncludeObject {
  IncidentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Incident.t;
}

class IncidentIncludeList extends _is.IncludeList {
  IncidentIncludeList._({
    _is.WhereExpressionBuilder<IncidentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Incident.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Incident.t;
}

class IncidentRepository {
  const IncidentRepository._();

  /// Returns a list of [Incident]s matching the given query parameters.
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
  Future<List<Incident>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Incident>(
      where: where?.call(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Incident] matching the given query parameters.
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
  Future<Incident?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Incident>(
      where: where?.call(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Incident] by its [id] or null if no such row exists.
  Future<Incident?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Incident>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Incident]s in the list and returns the inserted rows.
  ///
  /// The returned [Incident]s will have their `id` fields set.
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
  Future<List<Incident>> insert(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Incident>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Incident] and returns the inserted row.
  ///
  /// The returned [Incident] will have its `id` field set.
  Future<Incident> insertRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Incident>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Incident]s in the list and returns the resulting rows.
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
  /// The returned [Incident]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> upsert(
    _is.DatabaseSession session,
    List<Incident> rows, {
    required _is.ColumnSelections<IncidentTable> conflictColumns,
    _is.ColumnSelections<IncidentTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Incident>(
      rows,
      conflictColumns: conflictColumns(Incident.t),
      updateColumns: updateColumns?.call(Incident.t),
      updateWhere: updateWhere?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Incident] and returns the resulting row.
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
  /// The returned [Incident] will have its `id` field set.
  Future<Incident?> upsertRow(
    _is.DatabaseSession session,
    Incident row, {
    required _is.ColumnSelections<IncidentTable> conflictColumns,
    _is.ColumnSelections<IncidentTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Incident>(
      row,
      conflictColumns: conflictColumns(Incident.t),
      updateColumns: updateColumns?.call(Incident.t),
      updateWhere: updateWhere?.call(Incident.t),
      transaction: transaction,
    );
  }

  /// Updates all [Incident]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> update(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.ColumnSelections<IncidentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Incident>(
      rows,
      columns: columns?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Incident]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Incident> updateRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.ColumnSelections<IncidentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Incident>(
      row,
      columns: columns?.call(Incident.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Incident] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Incident?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IncidentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Incident>(
      id,
      columnValues: columnValues(Incident.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Incident]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IncidentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<IncidentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Incident>(
      columnValues: columnValues(Incident.t.updateTable),
      where: where(Incident.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Incident]s in the list and returns the deleted rows.
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
  Future<List<Incident>> delete(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Incident>(
      rows,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Incident].
  Future<Incident> deleteRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Incident>(
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
  Future<List<Incident>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentTable> where,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Incident>(
      where: where(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Incident>(
      where: where?.call(Incident.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Incident] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Incident>(
      where: where(Incident.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
