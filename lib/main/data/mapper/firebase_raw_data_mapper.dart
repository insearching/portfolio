/// Helpers to normalize Firebase Realtime Database snapshot values.
///
/// Firebase can return a Map (when using `.push()`) or a List.
Iterable<Map<String, dynamic>> firebaseRawToJsonMaps(Object? raw) sync* {
  if (raw is Map) {
    for (final entry in raw.entries) {
      final value = entry.value;
      if (value is Map) {
        yield Map<String, dynamic>.from(value);
      }
    }
    return;
  }

  if (raw is List) {
    for (final value in raw) {
      if (value is Map) {
        yield Map<String, dynamic>.from(value);
      }
    }
  }
}
