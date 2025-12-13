import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/typedefs.dart';

/// Remote static_data source for Positions
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
      final rawData = event.snapshot.value;
      final List<Position> positions = [];

      // Handle both Map (from .push()) and List formats
      if (rawData is Map) {
        // Firebase returns Map when using .push()
        for (var entry in rawData.entries) {
          final value = entry.value;
          if (value is Map) {
            final iconValue =
                value['icon']?.toString() ?? 'assets/img/android.png';
            positions.add(
              Position(
                title: value['title']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                position: value['position']?.toString() ?? '',
                icon: iconValue.isEmpty ? 'assets/img/android.png' : iconValue,
              ),
            );
          }
        }
      } else if (rawData is List) {
        // Handle List format (if data is structured as array)
        for (var value in rawData) {
          if (value is Map) {
            final iconValue =
                value['icon']?.toString() ?? 'assets/img/android.png';
            positions.add(
              Position(
                title: value['title']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                position: value['position']?.toString() ?? '',
                icon: iconValue.isEmpty ? 'assets/img/android.png' : iconValue,
              ),
            );
          }
        }
      }

      print('Loaded ${positions.length} positions from Firebase');
      return positions;
    } catch (e) {
      print('Error parsing positions from Firebase: $e');
      rethrow;
    }
  }
}
