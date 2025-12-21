import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:sqflite/sqflite.dart';

/// Local static_data source for Positions
/// Handles all SQLite database operations for positions caching
abstract class PositionsLocalDataSource {
  Future<void> savePosition(Position position);

  Future<void> savePositions(List<Position> positions);

  Future<List<Position>> getPositions();

  Future<void> clearCache();
}

class PositionsLocalDataSourceImpl implements PositionsLocalDataSource {
  PositionsLocalDataSourceImpl({
    required this.database,
    required this.logger,
  });

  final Database database;
  final AppLogger logger;
  static const String _tableName = 'positions';
  static const String _tag = 'PositionsLocalDataSource';

  @override
  Future<void> savePosition(Position position) async {
    try {
      await database.insert(
        _tableName,
        {
          'title': position.title,
          'position': position.position,
          'description': position.description,
          'icon': position.icon,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.debug('Position cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error('Error caching position in SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<void> savePositions(List<Position> positions) async {
    try {
      final batch = database.batch();

      // Clear existing cache first
      batch.delete(_tableName);

      // Insert all positions
      for (final position in positions) {
        batch.insert(
          _tableName,
          {
            'title': position.title,
            'position': position.position,
            'description': position.description,
            'icon': position.icon,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      logger.debug(
          '${positions.length} positions cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error('Error caching positions in SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<List<Position>> getPositions() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(_tableName);

      return List.generate(maps.length, (i) {
        return Position(
          title: maps[i]['title'] as String? ?? '',
          position: maps[i]['position'] as String? ?? '',
          description: maps[i]['description'] as String? ?? '',
          icon: maps[i]['icon'] as String? ?? 'assets/img/android.png',
        );
      });
    } catch (e, stackTrace) {
      logger.error(
          'Error getting cached positions from SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      logger.debug('Positions cache cleared successfully', _tag);
    } catch (e, stackTrace) {
      logger.error('Error clearing positions cache', e, stackTrace, _tag);
      rethrow;
    }
  }
}
