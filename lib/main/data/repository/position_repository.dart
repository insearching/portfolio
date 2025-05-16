import 'package:firebase_database/firebase_database.dart';
import 'package:portfolio/main/data/position.dart';

const String _collectionName = 'positions';

class PositionRepository {
  PositionRepository({
    required this.databaseReference,
  });

  final DatabaseReference databaseReference;

  Future<List<Position>> readPositions() async {
    final positionsCollection = databaseReference.child(_collectionName);
    final event = await positionsCollection.once();

    if (event.snapshot.value == null) return [];

    try {
      final List<dynamic> rawData = event.snapshot.value as List<dynamic>;
      final List<Position> positions = [];

      for (var value in rawData) {
        if (value is Map) {
          positions.add(
            Position(
              title: value['title']?.toString() ?? '',
              description: value['description']?.toString() ?? '',
              position: value['position']?.toString() ?? '',
              icon: value['icon']?.toString() ?? 'assets/img/android.png',
            ),
          );
        }
      }

      return positions;
    } catch (e) {
      print('Error parsing positions: $e');
      return [];
    }
  }
}
