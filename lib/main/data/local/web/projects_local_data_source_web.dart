import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Web-compatible local data source for Projects
/// Uses in-memory caching since SQLite is not available on web
abstract class ProjectsLocalDataSourceWeb {
  Future<void> cacheProject(Project project);

  Future<void> cacheProjects(List<Project> projects);

  Future<List<Project>> getCachedProjects();

  Future<void> clearCache();
}

class ProjectsLocalDataSourceWebImpl implements ProjectsLocalDataSourceWeb {
  final AppLogger logger;
  ProjectsLocalDataSourceWebImpl({
    required this.logger,
  });

  // In-memory cache for web
  final List<Project> _cache = [];

  @override
  Future<void> cacheProject(Project project) async {
    try {
      // Remove existing project with same title if exists
      _cache.removeWhere((p) => p.title == project.title);
      _cache.add(project);
      logger.debug('Project cached successfully in memory (web)', 'ProjectsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching project in memory', e, stackTrace, 'ProjectsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> cacheProjects(List<Project> projects) async {
    try {
      _cache.clear();
      _cache.addAll(projects);
      logger.debug('${projects.length} projects cached successfully in memory (web)', 'ProjectsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching projects in memory', e, stackTrace, 'ProjectsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getCachedProjects() async {
    try {
      return List.from(_cache);
    } catch (e, stackTrace) {
      logger.error('Error getting cached projects from memory', e, stackTrace, 'ProjectsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      logger.debug('Projects cache cleared successfully (web)', 'ProjectsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error clearing projects cache', e, stackTrace, 'ProjectsLocalDataSourceWeb');
      rethrow;
    }
  }
}
