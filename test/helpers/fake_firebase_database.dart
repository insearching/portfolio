import 'package:firebase_database/firebase_database.dart';

class FakeDatabaseReference implements DatabaseReference {
  FakeDatabaseReference._(
    this._store,
    this._path,
    this._pushCounter,
  );

  factory FakeDatabaseReference.root({Object? initialValue}) {
    return FakeDatabaseReference._(
      <String, Object?>{'__root__': initialValue},
      const <String>[],
      _PushCounter(),
    );
  }

  final Map<String, Object?> _store;
  final List<String> _path;
  final _PushCounter _pushCounter;

  Object? _readAtPath(List<String> path) {
    Object? current = _store['__root__'];
    for (final segment in path) {
      if (current is Map) {
        current = current[segment];
      } else {
        return null;
      }
    }
    return current;
  }

  void _writeAtPath(List<String> path, Object? value) {
    if (path.isEmpty) {
      _store['__root__'] = value;
      return;
    }

    Object? current = _store['__root__'];
    if (current == null || current is! Map) {
      current = <String, Object?>{};
      _store['__root__'] = current;
    }

    Map<dynamic, dynamic> map = current as Map;

    for (var i = 0; i < path.length - 1; i++) {
      final segment = path[i];
      final next = map[segment];
      if (next is Map) {
        map = next;
      } else {
        final newMap = <String, Object?>{};
        map[segment] = newMap;
        map = newMap;
      }
    }

    map[path.last] = value;
  }

  @override
  DatabaseReference child(String path) {
    final trimmed = path.trim();
    final parts = trimmed.isEmpty
        ? const <String>[]
        : trimmed.split('/').where((p) => p.isNotEmpty).toList();
    return FakeDatabaseReference._(
        _store, <String>[..._path, ...parts], _pushCounter);
  }

  @override
  DatabaseReference push() {
    final key = 'push_${_pushCounter.next()}';
    return child(key);
  }

  @override
  Future<void> set(Object? value) async {
    _writeAtPath(_path, value);
  }

  @override
  Future<DatabaseEvent> once([
    DatabaseEventType eventType = DatabaseEventType.value,
  ]) async {
    final value = _readAtPath(_path);
    return FakeDatabaseEvent(FakeDataSnapshot(value));
  }

  Object? debugReadValue() => _readAtPath(_path);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeDatabaseEvent implements DatabaseEvent {
  FakeDatabaseEvent(this._snapshot);

  final DataSnapshot _snapshot;

  @override
  DataSnapshot get snapshot => _snapshot;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeDataSnapshot implements DataSnapshot {
  FakeDataSnapshot(this._value);

  final Object? _value;

  @override
  Object? get value => _value;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PushCounter {
  int _value = 0;

  int next() {
    _value++;
    return _value;
  }
}
