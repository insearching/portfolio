import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/domain/model/position.dart';

/// Web-compatible local static_data source for Positions
/// Uses in-memory caching since SQLite is not available on web
abstract class PositionsLocalDataSourceWeb {
  Future<void> cachePosition(Position position);

  Future<void> cachePositions(List<Position> positions);

  Future<List<Position>> getCachedPositions();

  Future<void> clearCache();
}

class PositionsLocalDataSourceWebImpl implements PositionsLocalDataSourceWeb {
  final AppLogger logger;
  PositionsLocalDataSourceWebImpl({
    required this.logger,
  });

  // In-memory cache for web
  final List<Position> _cache = [];

  @override
  Future<void> cachePosition(Position position) async {
    try {
      // Remove existing position with same title if exists
      _cache.removeWhere((p) => p.title == position.title);
      _cache.add(position);
      logger.debug('Position cached successfully in memory (web)',
          'PositionsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching position in memory', e, stackTrace,
          'PositionsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> cachePositions(List<Position> positions) async {
    try {
      _cache.clear();
      _cache.addAll(positions);
      logger.debug(
          '${positions.length} positions cached successfully in memory (web)',
          'PositionsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching positions in memory', e, stackTrace,
          'PositionsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<List<Position>> getCachedPositions() async {
    try {
      return List.from(_cache);
    } catch (e, stackTrace) {
      logger.error('Error getting cached positions from memory', e, stackTrace,
          'PositionsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      logger.debug('Positions cache cleared successfully (web)',
          'PositionsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error clearing positions cache', e, stackTrace,
          'PositionsLocalDataSourceWeb');
      rethrow;
    }
  }
}
