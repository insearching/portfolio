import 'package:portfolio/main/data/position.dart';

/// Web-compatible local static_data source for Positions
/// Uses in-memory caching since SQLite is not available on web
abstract class PositionsLocalDataSourceWeb {
  Future<void> cachePosition(Position position);

  Future<void> cachePositions(List<Position> positions);

  Future<List<Position>> getCachedPositions();

  Future<void> clearCache();
}

class PositionsLocalDataSourceWebImpl implements PositionsLocalDataSourceWeb {
  PositionsLocalDataSourceWebImpl();

  // In-memory cache for web
  final List<Position> _cache = [];

  @override
  Future<void> cachePosition(Position position) async {
    try {
      // Remove existing position with same title if exists
      _cache.removeWhere((p) => p.title == position.title);
      _cache.add(position);
      print('Position cached successfully in memory (web)');
    } catch (e) {
      print('Error caching position in memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> cachePositions(List<Position> positions) async {
    try {
      _cache.clear();
      _cache.addAll(positions);
      print(
          '${positions.length} positions cached successfully in memory (web)');
    } catch (e) {
      print('Error caching positions in memory: $e');
      rethrow;
    }
  }

  @override
  Future<List<Position>> getCachedPositions() async {
    try {
      return List.from(_cache);
    } catch (e) {
      print('Error getting cached positions from memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      print('Positions cache cleared successfully (web)');
    } catch (e) {
      print('Error clearing positions cache: $e');
      rethrow;
    }
  }
}
