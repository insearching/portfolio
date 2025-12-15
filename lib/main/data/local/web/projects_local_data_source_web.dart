import 'package:portfolio/main/domain/model/project.dart';

/// Web-compatible local data source for Projects
/// Uses in-memory caching since SQLite is not available on web
abstract class ProjectsLocalDataSourceWeb {
  Future<void> cacheProject(Project project);

  Future<void> cacheProjects(List<Project> projects);

  Future<List<Project>> getCachedProjects();

  Future<void> clearCache();
}

class ProjectsLocalDataSourceWebImpl implements ProjectsLocalDataSourceWeb {
  ProjectsLocalDataSourceWebImpl();

  // In-memory cache for web
  final List<Project> _cache = [];

  @override
  Future<void> cacheProject(Project project) async {
    try {
      // Remove existing project with same title if exists
      _cache.removeWhere((p) => p.title == project.title);
      _cache.add(project);
      print('Project cached successfully in memory (web)');
    } catch (e) {
      print('Error caching project in memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> cacheProjects(List<Project> projects) async {
    try {
      _cache.clear();
      _cache.addAll(projects);
      print('${projects.length} projects cached successfully in memory (web)');
    } catch (e) {
      print('Error caching projects in memory: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getCachedProjects() async {
    try {
      return List.from(_cache);
    } catch (e) {
      print('Error getting cached projects from memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      print('Projects cache cleared successfully (web)');
    } catch (e) {
      print('Error clearing projects cache: $e');
      rethrow;
    }
  }
}
