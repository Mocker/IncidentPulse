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

abstract class EscalationPolicy
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = EscalationPolicyTable();

  static const db = EscalationPolicyRepository._();

  @override
  int? id;

  int serviceId;

  int timeoutMinutes;

  String? notifyEmail;

  String? notifyWebhookUrl;

  bool isActive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EscalationPolicy]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static EscalationPolicyInclude include() {
    return EscalationPolicyInclude._();
  }

  static EscalationPolicyIncludeList includeList({
    _is.WhereExpressionBuilder<EscalationPolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EscalationPolicyTable>? orderBy,
    _is.OrderByListBuilder<EscalationPolicyTable>? orderByList,
    EscalationPolicyInclude? include,
  }) {
    return EscalationPolicyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EscalationPolicy.t),
      orderByList: orderByList?.call(EscalationPolicy.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class EscalationPolicyUpdateTable
    extends _is.UpdateTable<EscalationPolicyTable> {
  EscalationPolicyUpdateTable(super.table);

  _is.ColumnValue<int, int> serviceId(int value) => _is.ColumnValue(
        table.serviceId,
        value,
      );

  _is.ColumnValue<int, int> timeoutMinutes(int value) => _is.ColumnValue(
        table.timeoutMinutes,
        value,
      );

  _is.ColumnValue<String, String> notifyEmail(String? value) => _is.ColumnValue(
        table.notifyEmail,
        value,
      );

  _is.ColumnValue<String, String> notifyWebhookUrl(String? value) =>
      _is.ColumnValue(
        table.notifyWebhookUrl,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
        table.isActive,
        value,
      );
}

class EscalationPolicyTable extends _is.Table<int?> {
  EscalationPolicyTable({super.tableRelation})
      : super(tableName: 'escalation_policy') {
    updateTable = EscalationPolicyUpdateTable(this);
    serviceId = _is.ColumnInt(
      'serviceId',
      this,
    );
    timeoutMinutes = _is.ColumnInt(
      'timeoutMinutes',
      this,
    );
    notifyEmail = _is.ColumnString(
      'notifyEmail',
      this,
    );
    notifyWebhookUrl = _is.ColumnString(
      'notifyWebhookUrl',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
  }

  late final EscalationPolicyUpdateTable updateTable;

  late final _is.ColumnInt serviceId;

  late final _is.ColumnInt timeoutMinutes;

  late final _is.ColumnString notifyEmail;

  late final _is.ColumnString notifyWebhookUrl;

  late final _is.ColumnBool isActive;

  @override
  List<_is.Column> get columns => [
        id,
        serviceId,
        timeoutMinutes,
        notifyEmail,
        notifyWebhookUrl,
        isActive,
      ];
}

class EscalationPolicyInclude extends _is.IncludeObject {
  EscalationPolicyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EscalationPolicy.t;
}

class EscalationPolicyIncludeList extends _is.IncludeList {
  EscalationPolicyIncludeList._({
    _is.WhereExpressionBuilder<EscalationPolicyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EscalationPolicy.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EscalationPolicy.t;
}

class EscalationPolicyRepository {
  const EscalationPolicyRepository._();

  /// Returns a list of [EscalationPolicy]s matching the given query parameters.
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
  Future<List<EscalationPolicy>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EscalationPolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EscalationPolicyTable>? orderBy,
    _is.OrderByListBuilder<EscalationPolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EscalationPolicy>(
      where: where?.call(EscalationPolicy.t),
      orderBy: orderBy?.call(EscalationPolicy.t),
      orderByList: orderByList?.call(EscalationPolicy.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EscalationPolicy] matching the given query parameters.
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
  Future<EscalationPolicy?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EscalationPolicyTable>? where,
    int? offset,
    _is.OrderByBuilder<EscalationPolicyTable>? orderBy,
    _is.OrderByListBuilder<EscalationPolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EscalationPolicy>(
      where: where?.call(EscalationPolicy.t),
      orderBy: orderBy?.call(EscalationPolicy.t),
      orderByList: orderByList?.call(EscalationPolicy.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EscalationPolicy] by its [id] or null if no such row exists.
  Future<EscalationPolicy?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EscalationPolicy>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EscalationPolicy]s in the list and returns the inserted rows.
  ///
  /// The returned [EscalationPolicy]s will have their `id` fields set.
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
  Future<List<EscalationPolicy>> insert(
    _is.DatabaseSession session,
    List<EscalationPolicy> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EscalationPolicy>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EscalationPolicy] and returns the inserted row.
  ///
  /// The returned [EscalationPolicy] will have its `id` field set.
  Future<EscalationPolicy> insertRow(
    _is.DatabaseSession session,
    EscalationPolicy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EscalationPolicy>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EscalationPolicy]s in the list and returns the resulting rows.
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
  /// The returned [EscalationPolicy]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EscalationPolicy>> upsert(
    _is.DatabaseSession session,
    List<EscalationPolicy> rows, {
    required _is.ColumnSelections<EscalationPolicyTable> conflictColumns,
    _is.ColumnSelections<EscalationPolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<EscalationPolicyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EscalationPolicy>(
      rows,
      conflictColumns: conflictColumns(EscalationPolicy.t),
      updateColumns: updateColumns?.call(EscalationPolicy.t),
      updateWhere: updateWhere?.call(EscalationPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EscalationPolicy] and returns the resulting row.
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
  /// The returned [EscalationPolicy] will have its `id` field set.
  Future<EscalationPolicy?> upsertRow(
    _is.DatabaseSession session,
    EscalationPolicy row, {
    required _is.ColumnSelections<EscalationPolicyTable> conflictColumns,
    _is.ColumnSelections<EscalationPolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<EscalationPolicyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EscalationPolicy>(
      row,
      conflictColumns: conflictColumns(EscalationPolicy.t),
      updateColumns: updateColumns?.call(EscalationPolicy.t),
      updateWhere: updateWhere?.call(EscalationPolicy.t),
      transaction: transaction,
    );
  }

  /// Updates all [EscalationPolicy]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EscalationPolicy>> update(
    _is.DatabaseSession session,
    List<EscalationPolicy> rows, {
    _is.ColumnSelections<EscalationPolicyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EscalationPolicy>(
      rows,
      columns: columns?.call(EscalationPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EscalationPolicy]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EscalationPolicy> updateRow(
    _is.DatabaseSession session,
    EscalationPolicy row, {
    _is.ColumnSelections<EscalationPolicyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EscalationPolicy>(
      row,
      columns: columns?.call(EscalationPolicy.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EscalationPolicy] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EscalationPolicy?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EscalationPolicyUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EscalationPolicy>(
      id,
      columnValues: columnValues(EscalationPolicy.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EscalationPolicy]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EscalationPolicy>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EscalationPolicyUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<EscalationPolicyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EscalationPolicyTable>? orderBy,
    _is.OrderByListBuilder<EscalationPolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EscalationPolicy>(
      columnValues: columnValues(EscalationPolicy.t.updateTable),
      where: where(EscalationPolicy.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EscalationPolicy.t),
      orderByList: orderByList?.call(EscalationPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EscalationPolicy]s in the list and returns the deleted rows.
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
  Future<List<EscalationPolicy>> delete(
    _is.DatabaseSession session,
    List<EscalationPolicy> rows, {
    _is.OrderByBuilder<EscalationPolicyTable>? orderBy,
    _is.OrderByListBuilder<EscalationPolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EscalationPolicy>(
      rows,
      orderBy: orderBy?.call(EscalationPolicy.t),
      orderByList: orderByList?.call(EscalationPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EscalationPolicy].
  Future<EscalationPolicy> deleteRow(
    _is.DatabaseSession session,
    EscalationPolicy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EscalationPolicy>(
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
  Future<List<EscalationPolicy>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EscalationPolicyTable> where,
    _is.OrderByBuilder<EscalationPolicyTable>? orderBy,
    _is.OrderByListBuilder<EscalationPolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EscalationPolicy>(
      where: where(EscalationPolicy.t),
      orderBy: orderBy?.call(EscalationPolicy.t),
      orderByList: orderByList?.call(EscalationPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EscalationPolicyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EscalationPolicy>(
      where: where?.call(EscalationPolicy.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EscalationPolicy] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EscalationPolicyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EscalationPolicy>(
      where: where(EscalationPolicy.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
