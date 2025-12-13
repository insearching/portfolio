import 'package:portfolio/main/data/local/sqlite/positions_local_data_source.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
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
  });

  @override
  Future<List<Position>> readPositions() async {
    // For backward compatibility, return the last emitted value from the stream
    return await fetchWithCache(entityName: 'positions').last;
  }

  /// Returns a Stream that emits positions progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Position>> readPositionsStream() {
    return fetchWithCache(entityName: 'positions');
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  Future<List<Position>> refreshPositions() async {
    return await refresh(entityName: 'positions').last;
  }

  /// Returns a Stream for refresh that emits fresh data
  Stream<List<Position>> refreshPositionsStream() {
    return refresh(entityName: 'positions');
  }

  /// Stream that notifies when positions are updated from remote
  Stream<List<Position>> get positionsUpdateStream => dataStream;

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
