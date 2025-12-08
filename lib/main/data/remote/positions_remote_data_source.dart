import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/typedefs.dart';

/// Remote data source for Positions
/// Handles all Firebase Realtime Database operations for positions
abstract class PositionsRemoteDataSource {
  Future<List<Position>> readPositions();
}

class PositionsRemoteDataSourceImpl implements PositionsRemoteDataSource {
  PositionsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'positions';

  @override
  Future<List<Position>> readPositions() async {
    final positionsCollection =
        firebaseDatabaseReference.child(_collectionName);
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
      print('Error parsing positions from Firebase: $e');
      rethrow;
    }
  }
}
