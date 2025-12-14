import 'package:portfolio/main/data/skill.dart';
import 'package:sqflite/sqflite.dart';

/// Local data source for Skills
/// Handles all SQLite database operations for skills caching
abstract class SkillsLocalDataSource {
  Future<void> saveSkill(Skill skill);

  Future<void> saveSkills(List<Skill> skills);

  Future<List<Skill>> getSkills();

  Future<void> clearCache();
}

class SkillsLocalDataSourceImpl implements SkillsLocalDataSource {
  SkillsLocalDataSourceImpl({
    required this.database,
  });

  final Database database;
  static const String _tableName = 'skills';

  @override
  Future<void> saveSkill(Skill skill) async {
    try {
      await database.insert(
        _tableName,
        {
          'title': skill.title,
          'value': skill.value,
          'type': skill.type.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Skill cached successfully in SQLite');
    } catch (e) {
      print('Error caching skill in SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveSkills(List<Skill> skills) async {
    try {
      final batch = database.batch();

      // Clear existing cache first
      batch.delete(_tableName);

      // Insert all skills
      for (final skill in skills) {
        batch.insert(
          _tableName,
          {
            'title': skill.title,
            'value': skill.value,
            'type': skill.type.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      print('${skills.length} skills cached successfully in SQLite');
    } catch (e) {
      print('Error caching skills in SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<List<Skill>> getSkills() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(_tableName);

      return List.generate(maps.length, (i) {
        final typeString = maps[i]['type'] as String? ?? 'hard';
        final type = typeString.toLowerCase() == 'soft'
            ? SkillType.soft
            : SkillType.hard;

        return Skill(
          title: maps[i]['title'] as String? ?? '',
          value: maps[i]['value'] as int? ?? 0,
          type: type,
        );
      });
    } catch (e) {
      print('Error getting cached skills from SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      print('Skills cache cleared successfully');
    } catch (e) {
      print('Error clearing skills cache: $e');
      rethrow;
    }
  }
}
