import 'package:portfolio/main/data/local/positions_local_data_source.dart';
import 'package:portfolio/main/data/position.dart';
import 'package:portfolio/main/data/remote/positions_remote_data_source.dart';

/// Data Access Object for Positions
/// Handles both remote and local data operations with caching strategy
abstract class PositionDao {
  Future<List<Position>> readPositions();
}

class PositionDaoImpl implements PositionDao {
  PositionDaoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final PositionsRemoteDataSource remoteDataSource;
  final PositionsLocalDataSource localDataSource;

  @override
  Future<List<Position>> readPositions() async {
    try {
      // Try to fetch from remote
      final remotePositions = await remoteDataSource.readPositions();

      // Cache the remote data
      if (remotePositions.isNotEmpty) {
        await localDataSource.savePositions(remotePositions);
      }

      return remotePositions;
    } catch (e) {
      print('Error fetching from remote, trying local cache: $e');

      // Fallback to local cache if remote fails
      try {
        final cachedPositions = await localDataSource.getPositions();
        print('Returned ${cachedPositions.length} positions from local cache');
        return cachedPositions;
      } catch (cacheError) {
        print('Error reading from cache: $cacheError');
        return [];
      }
    }
  }
}
