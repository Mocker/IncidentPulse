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

abstract class ReliabilityReport
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['generatedAt']),
    );
  }

  static final t = ReliabilityReportTable();

  static const db = ReliabilityReportRepository._();

  @override
  int? id;

  int serviceId;

  double uptimePercent;

  int incidentCount;

  double mttrMinutes;

  double healthScore;

  String reportSummary;

  DateTime generatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReliabilityReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static ReliabilityReportInclude include() {
    return ReliabilityReportInclude._();
  }

  static ReliabilityReportIncludeList includeList({
    _is.WhereExpressionBuilder<ReliabilityReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReliabilityReportTable>? orderBy,
    _is.OrderByListBuilder<ReliabilityReportTable>? orderByList,
    ReliabilityReportInclude? include,
  }) {
    return ReliabilityReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReliabilityReport.t),
      orderByList: orderByList?.call(ReliabilityReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class ReliabilityReportUpdateTable
    extends _is.UpdateTable<ReliabilityReportTable> {
  ReliabilityReportUpdateTable(super.table);

  _is.ColumnValue<int, int> serviceId(int value) => _is.ColumnValue(
        table.serviceId,
        value,
      );

  _is.ColumnValue<double, double> uptimePercent(double value) =>
      _is.ColumnValue(
        table.uptimePercent,
        value,
      );

  _is.ColumnValue<int, int> incidentCount(int value) => _is.ColumnValue(
        table.incidentCount,
        value,
      );

  _is.ColumnValue<double, double> mttrMinutes(double value) => _is.ColumnValue(
        table.mttrMinutes,
        value,
      );

  _is.ColumnValue<double, double> healthScore(double value) => _is.ColumnValue(
        table.healthScore,
        value,
      );

  _is.ColumnValue<String, String> reportSummary(String value) =>
      _is.ColumnValue(
        table.reportSummary,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> generatedAt(DateTime value) =>
      _is.ColumnValue(
        table.generatedAt,
        value,
      );
}

class ReliabilityReportTable extends _is.Table<int?> {
  ReliabilityReportTable({super.tableRelation})
      : super(tableName: 'reliability_report') {
    updateTable = ReliabilityReportUpdateTable(this);
    serviceId = _is.ColumnInt(
      'serviceId',
      this,
    );
    uptimePercent = _is.ColumnDouble(
      'uptimePercent',
      this,
    );
    incidentCount = _is.ColumnInt(
      'incidentCount',
      this,
    );
    mttrMinutes = _is.ColumnDouble(
      'mttrMinutes',
      this,
    );
    healthScore = _is.ColumnDouble(
      'healthScore',
      this,
    );
    reportSummary = _is.ColumnString(
      'reportSummary',
      this,
    );
    generatedAt = _is.ColumnDateTime(
      'generatedAt',
      this,
    );
  }

  late final ReliabilityReportUpdateTable updateTable;

  late final _is.ColumnInt serviceId;

  late final _is.ColumnDouble uptimePercent;

  late final _is.ColumnInt incidentCount;

  late final _is.ColumnDouble mttrMinutes;

  late final _is.ColumnDouble healthScore;

  late final _is.ColumnString reportSummary;

  late final _is.ColumnDateTime generatedAt;

  @override
  List<_is.Column> get columns => [
        id,
        serviceId,
        uptimePercent,
        incidentCount,
        mttrMinutes,
        healthScore,
        reportSummary,
        generatedAt,
      ];
}

class ReliabilityReportInclude extends _is.IncludeObject {
  ReliabilityReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ReliabilityReport.t;
}

class ReliabilityReportIncludeList extends _is.IncludeList {
  ReliabilityReportIncludeList._({
    _is.WhereExpressionBuilder<ReliabilityReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReliabilityReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ReliabilityReport.t;
}

class ReliabilityReportRepository {
  const ReliabilityReportRepository._();

  /// Returns a list of [ReliabilityReport]s matching the given query parameters.
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
  Future<List<ReliabilityReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReliabilityReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReliabilityReportTable>? orderBy,
    _is.OrderByListBuilder<ReliabilityReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReliabilityReport>(
      where: where?.call(ReliabilityReport.t),
      orderBy: orderBy?.call(ReliabilityReport.t),
      orderByList: orderByList?.call(ReliabilityReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReliabilityReport] matching the given query parameters.
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
  Future<ReliabilityReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReliabilityReportTable>? where,
    int? offset,
    _is.OrderByBuilder<ReliabilityReportTable>? orderBy,
    _is.OrderByListBuilder<ReliabilityReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReliabilityReport>(
      where: where?.call(ReliabilityReport.t),
      orderBy: orderBy?.call(ReliabilityReport.t),
      orderByList: orderByList?.call(ReliabilityReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReliabilityReport] by its [id] or null if no such row exists.
  Future<ReliabilityReport?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReliabilityReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReliabilityReport]s in the list and returns the inserted rows.
  ///
  /// The returned [ReliabilityReport]s will have their `id` fields set.
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
  Future<List<ReliabilityReport>> insert(
    _is.DatabaseSession session,
    List<ReliabilityReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReliabilityReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReliabilityReport] and returns the inserted row.
  ///
  /// The returned [ReliabilityReport] will have its `id` field set.
  Future<ReliabilityReport> insertRow(
    _is.DatabaseSession session,
    ReliabilityReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReliabilityReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReliabilityReport]s in the list and returns the resulting rows.
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
  /// The returned [ReliabilityReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReliabilityReport>> upsert(
    _is.DatabaseSession session,
    List<ReliabilityReport> rows, {
    required _is.ColumnSelections<ReliabilityReportTable> conflictColumns,
    _is.ColumnSelections<ReliabilityReportTable>? updateColumns,
    _is.WhereExpressionBuilder<ReliabilityReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReliabilityReport>(
      rows,
      conflictColumns: conflictColumns(ReliabilityReport.t),
      updateColumns: updateColumns?.call(ReliabilityReport.t),
      updateWhere: updateWhere?.call(ReliabilityReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReliabilityReport] and returns the resulting row.
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
  /// The returned [ReliabilityReport] will have its `id` field set.
  Future<ReliabilityReport?> upsertRow(
    _is.DatabaseSession session,
    ReliabilityReport row, {
    required _is.ColumnSelections<ReliabilityReportTable> conflictColumns,
    _is.ColumnSelections<ReliabilityReportTable>? updateColumns,
    _is.WhereExpressionBuilder<ReliabilityReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReliabilityReport>(
      row,
      conflictColumns: conflictColumns(ReliabilityReport.t),
      updateColumns: updateColumns?.call(ReliabilityReport.t),
      updateWhere: updateWhere?.call(ReliabilityReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReliabilityReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReliabilityReport>> update(
    _is.DatabaseSession session,
    List<ReliabilityReport> rows, {
    _is.ColumnSelections<ReliabilityReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReliabilityReport>(
      rows,
      columns: columns?.call(ReliabilityReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReliabilityReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReliabilityReport> updateRow(
    _is.DatabaseSession session,
    ReliabilityReport row, {
    _is.ColumnSelections<ReliabilityReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReliabilityReport>(
      row,
      columns: columns?.call(ReliabilityReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReliabilityReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReliabilityReport?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ReliabilityReportUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReliabilityReport>(
      id,
      columnValues: columnValues(ReliabilityReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReliabilityReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReliabilityReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReliabilityReportUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<ReliabilityReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReliabilityReportTable>? orderBy,
    _is.OrderByListBuilder<ReliabilityReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReliabilityReport>(
      columnValues: columnValues(ReliabilityReport.t.updateTable),
      where: where(ReliabilityReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReliabilityReport.t),
      orderByList: orderByList?.call(ReliabilityReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReliabilityReport]s in the list and returns the deleted rows.
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
  Future<List<ReliabilityReport>> delete(
    _is.DatabaseSession session,
    List<ReliabilityReport> rows, {
    _is.OrderByBuilder<ReliabilityReportTable>? orderBy,
    _is.OrderByListBuilder<ReliabilityReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReliabilityReport>(
      rows,
      orderBy: orderBy?.call(ReliabilityReport.t),
      orderByList: orderByList?.call(ReliabilityReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReliabilityReport].
  Future<ReliabilityReport> deleteRow(
    _is.DatabaseSession session,
    ReliabilityReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReliabilityReport>(
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
  Future<List<ReliabilityReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReliabilityReportTable> where,
    _is.OrderByBuilder<ReliabilityReportTable>? orderBy,
    _is.OrderByListBuilder<ReliabilityReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReliabilityReport>(
      where: where(ReliabilityReport.t),
      orderBy: orderBy?.call(ReliabilityReport.t),
      orderByList: orderByList?.call(ReliabilityReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReliabilityReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReliabilityReport>(
      where: where?.call(ReliabilityReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReliabilityReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReliabilityReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReliabilityReport>(
      where: where(ReliabilityReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
