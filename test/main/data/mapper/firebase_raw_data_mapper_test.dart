import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';

void main() {
  group('firebaseRawToJsonMaps', () {
    test('yields map entries when raw is Map', () {
      final raw = {
        'a': {'x': 1},
        'b': {'y': 2},
        'c': 'not a map',
      };

      final items = firebaseRawToJsonMaps(raw).toList();
      expect(items, [
        {'x': 1},
        {'y': 2},
      ]);
    });

    test('yields list entries when raw is List', () {
      final raw = [
        {'a': 1},
        'nope',
        {'b': 2},
      ];

      final items = firebaseRawToJsonMaps(raw).toList();
      expect(items, [
        {'a': 1},
        {'b': 2},
      ]);
    });
  });
}
