import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/position_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Remote static_data source for Positions
/// Handles all Firebase Realtime Database operations for positions
abstract class PositionsRemoteDataSource {
  Future<void> addPosition(Position position);

  Future<List<Position>> readPositions();
}

class PositionsRemoteDataSourceImpl implements PositionsRemoteDataSource {
  PositionsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
    required this.logger,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  final AppLogger logger;
  static const String _collectionName = 'positions';

  @override
  Future<void> addPosition(Position position) async {
    final positionsCollection =
        firebaseDatabaseReference.child(_collectionName);

    try {
      final model = positionRemoteModelFromDomain(position);
      await positionsCollection.push().set(model.toJson());
      logger.debug('Position added successfully to Firebase',
          'PositionsRemoteDataSource');
    } catch (e, stackTrace) {
      logger.error('Error adding position to Firebase', e, stackTrace,
          'PositionsRemoteDataSource');
      rethrow;
    }
  }

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

      logger.debug('Loaded ${positions.length} positions from Firebase',
          'PositionsRemoteDataSource');
      return positions;
    } catch (e, stackTrace) {
      logger.error('Error parsing positions from Firebase', e, stackTrace,
          'PositionsRemoteDataSource');
      rethrow;
    }
  }
}
