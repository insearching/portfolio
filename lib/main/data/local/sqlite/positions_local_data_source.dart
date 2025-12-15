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
  });

  final Database database;
  static const String _tableName = 'positions';

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
      print('Position cached successfully in SQLite');
    } catch (e) {
      print('Error caching position in SQLite: $e');
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
      print('${positions.length} positions cached successfully in SQLite');
    } catch (e) {
      print('Error caching positions in SQLite: $e');
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
    } catch (e) {
      print('Error getting cached positions from SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      print('Positions cache cleared successfully');
    } catch (e) {
      print('Error clearing positions cache: $e');
      rethrow;
    }
  }
}
