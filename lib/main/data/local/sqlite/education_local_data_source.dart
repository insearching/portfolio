import 'package:portfolio/main/domain/model/education.dart';
import 'package:sqflite/sqflite.dart';

/// Local data source for Education
/// Handles all SQLite database operations for education records caching
abstract class EducationLocalDataSource {
  Future<void> saveEducation(Education education);

  Future<void> saveEducationList(List<Education> educationList);

  Future<List<Education>> getEducation();

  Future<void> clearCache();
}

class EducationLocalDataSourceImpl implements EducationLocalDataSource {
  EducationLocalDataSourceImpl({
    required this.database,
  });

  final Database database;
  static const String _tableName = 'education';

  @override
  Future<void> saveEducation(Education education) async {
    try {
      await database.insert(
        _tableName,
        {
          'title': education.title,
          'description': education.description,
          'type': education.type.name,
          'text': education.text,
          'link': education.link,
          'imageUrl': education.imageUrl,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Education record cached successfully in SQLite');
    } catch (e) {
      print('Error caching education record in SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveEducationList(List<Education> educationList) async {
    try {
      final batch = database.batch();

      // Clear existing cache first
      batch.delete(_tableName);

      // Insert all education records
      for (final education in educationList) {
        batch.insert(
          _tableName,
          {
            'title': education.title,
            'description': education.description,
            'type': education.type.name,
            'text': education.text,
            'link': education.link,
            'imageUrl': education.imageUrl,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      print(
          '${educationList.length} education records cached successfully in SQLite');
    } catch (e) {
      print('Error caching education records in SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<List<Education>> getEducation() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(_tableName);

      return List.generate(maps.length, (i) {
        return Education(
          title: maps[i]['title'] as String? ?? '',
          description: maps[i]['description'] as String? ?? '',
          type: EducationType.values.firstWhere(
            (e) => e.name == (maps[i]['type'] as String? ?? 'certification'),
            orElse: () => EducationType.certification,
          ),
          text: maps[i]['text'] as String?,
          link: maps[i]['link'] as String?,
          imageUrl: maps[i]['imageUrl'] as String?,
        );
      });
    } catch (e) {
      print('Error getting cached education records from SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      print('Education cache cleared successfully');
    } catch (e) {
      print('Error clearing education cache: $e');
      rethrow;
    }
  }
}
