import 'package:portfolio/main/domain/model/project.dart';
import 'package:sqflite/sqflite.dart';

/// Local data source for Projects
/// Handles all SQLite database operations for projects caching
abstract class ProjectsLocalDataSource {
  Future<void> saveProject(Project project);

  Future<void> saveProjects(List<Project> projects);

  Future<List<Project>> getProjects();

  Future<void> clearCache();
}

class ProjectsLocalDataSourceImpl implements ProjectsLocalDataSource {
  ProjectsLocalDataSourceImpl({
    required this.database,
  });

  final Database database;
  static const String _tableName = 'projects';

  @override
  Future<void> saveProject(Project project) async {
    try {
      await database.insert(
        _tableName,
        {
          'image': project.image,
          'title': project.title,
          'role': project.role,
          'description': project.description,
          'link': project.link,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Project cached successfully in SQLite');
    } catch (e) {
      print('Error caching project in SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveProjects(List<Project> projects) async {
    try {
      final batch = database.batch();

      // Clear existing cache first
      batch.delete(_tableName);

      // Insert all projects
      for (final project in projects) {
        batch.insert(
          _tableName,
          {
            'image': project.image,
            'title': project.title,
            'role': project.role,
            'description': project.description,
            'link': project.link,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      print('${projects.length} projects cached successfully in SQLite');
    } catch (e) {
      print('Error caching projects in SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getProjects() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(_tableName);

      return List.generate(maps.length, (i) {
        return Project(
          image: maps[i]['image'] as String? ?? 'assets/img/default.png',
          title: maps[i]['title'] as String? ?? '',
          role: maps[i]['role'] as String? ?? '',
          description: maps[i]['description'] as String? ?? '',
          link: maps[i]['link'] as String?,
        );
      });
    } catch (e) {
      print('Error getting cached projects from SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      print('Projects cache cleared successfully');
    } catch (e) {
      print('Error clearing projects cache: $e');
      rethrow;
    }
  }
}
