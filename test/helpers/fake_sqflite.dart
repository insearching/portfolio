import 'package:sqflite/sqflite.dart';

class FakeDatabase implements Database {
  final Map<String, List<Map<String, Object?>>> _tables = {};

  int _autoId = 0;

  List<Map<String, Object?>> _table(String name) =>
      _tables.putIfAbsent(name, () => <Map<String, Object?>>[]);

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    _autoId++;
    _table(table).add(Map<String, Object?>.from(values));
    return _autoId;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final t = _table(table);
    final count = t.length;
    t.clear();
    return count;
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final t = List<Map<String, Object?>>.from(_table(table));
    if (limit != null && t.length > limit) {
      return t.take(limit).toList();
    }
    return t;
  }

  @override
  Batch batch() => FakeBatch(this);

  void _applyBatchDelete(String table) {
    _table(table).clear();
  }

  void _applyBatchInsert(String table, Map<String, Object?> values) {
    _table(table).add(Map<String, Object?>.from(values));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeBatch implements Batch {
  FakeBatch(this._db);

  final FakeDatabase _db;

  final List<void Function()> _ops = [];

  @override
  void delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) {
    _ops.add(() => _db._applyBatchDelete(table));
  }

  @override
  void insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    _ops.add(() => _db._applyBatchInsert(table, values));
  }

  @override
  Future<List<Object?>> commit({
    bool? exclusive,
    bool? noResult,
    bool? continueOnError,
  }) async {
    for (final op in _ops) {
      op();
    }
    return const <Object?>[];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
