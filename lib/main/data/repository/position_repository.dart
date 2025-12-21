import 'package:portfolio/main/data/local/sqlite/positions_local_data_source.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';

/// Implementation of PositionRepository
/// Extends BaseRepository to leverage common 3-tier caching logic
class PositionRepositoryImpl extends BaseRepository<
    Position,
    PositionsRemoteDataSource,
    PositionsLocalDataSource> implements PositionRepository {
  PositionRepositoryImpl({
    required super.remoteDataSource,
    required super.localDataSource,
    required super.logger,
  });

  @override
  Future<void> addPosition(Position position) async {
    try {
      // Add to remote first
      await remoteDataSource.addPosition(position);

      // Update memory cache if it exists
      updateMemoryCacheWithItem(position);
    } catch (e) {
      throw Exception('Failed to add position: $e');
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  @override
  Future<List<Position>> refreshPositions() async {
    return await refresh(entityName: 'positions').last;
  }

  /// Stream that emits positions progressively from cache layers
  /// Emits from: memory -> local -> remote
  @override
  Stream<List<Position>> get positionsUpdateStream =>
      fetchWithCache(entityName: 'positions');

  // Implement abstract methods from BaseRepository

  @override
  Future<List<Position>> fetchFromRemote() async {
    return await remoteDataSource.readPositions();
  }

  @override
  Future<List<Position>> fetchFromLocal() async {
    return await localDataSource.getPositions();
  }

  @override
  Future<void> saveToLocal(List<Position> items) async {
    await localDataSource.savePositions(items);
  }

  @override
  Future<void> clearLocalCache() async {
    await localDataSource.clearCache();
  }
}
