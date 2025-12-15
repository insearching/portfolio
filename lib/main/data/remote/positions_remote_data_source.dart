import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/position_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/position.dart';

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

    final rawData = event.snapshot.value;
    if (rawData == null) return [];

    try {
      final positions = firebaseRawToJsonMaps(rawData)
          .map(positionRemoteModelFromJson)
          .map((m) => m.toDomain())
          .toList();

      print('Loaded ${positions.length} positions from Firebase');
      return positions;
    } catch (e) {
      print('Error parsing positions from Firebase: $e');
      rethrow;
    }
  }
}
