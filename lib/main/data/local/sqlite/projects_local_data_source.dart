import 'package:portfolio/core/logger/app_logger.dart';
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
    required this.logger,
  });

  final Database database;
  final AppLogger logger;
  static const String _tableName = 'projects';
  static const String _tag = 'ProjectsLocalDataSource';

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
          'order': project.order,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.debug('Project cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error('Error caching project in SQLite', e, stackTrace, _tag);
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
            'order': project.order,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      logger.debug(
          '${projects.length} projects cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error('Error caching projects in SQLite', e, stackTrace, _tag);
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
          order: maps[i]['order'] as int? ?? 0,
        );
      });
    } catch (e, stackTrace) {
      logger.error(
          'Error getting cached projects from SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      logger.debug('Projects cache cleared successfully', _tag);
    } catch (e, stackTrace) {
      logger.error('Error clearing projects cache', e, stackTrace, _tag);
      rethrow;
    }
  }
}
