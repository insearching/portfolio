import 'package:portfolio/main/data/local/sqlite/projects_local_data_source.dart';
import 'package:portfolio/main/data/remote/projects_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';

/// Implementation of ProjectRepository
/// Extends BaseRepository to leverage common 3-tier caching logic
class ProjectRepositoryImpl extends BaseRepository<
    Project,
    ProjectsRemoteDataSource,
    ProjectsLocalDataSource> implements ProjectRepository {
  ProjectRepositoryImpl({
    required super.remoteDataSource,
    required super.localDataSource,
  });

  @override
  Future<void> addProject(Project project) async {
    try {
      // Add to remote first
      await remoteDataSource.addProject(project);

      // Update memory cache if it exists
      updateMemoryCacheWithItem(project);
    } catch (e) {
      throw Exception('Failed to add project: $e');
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  @override
  Future<List<Project>> refreshProjects() async {
    return await refresh(entityName: 'projects').last;
  }

  /// Stream that emits projects progressively from cache layers
  /// Emits from: memory -> local -> remote
  @override
  Stream<List<Project>> get projectsUpdateStream =>
      fetchWithCache(entityName: 'projects');

  // Implement abstract methods from BaseRepository

  @override
  Future<List<Project>> fetchFromRemote() async {
    return await remoteDataSource.readProjects();
  }

  @override
  Future<List<Project>> fetchFromLocal() async {
    return await localDataSource.getProjects();
  }

  @override
  Future<void> saveToLocal(List<Project> items) async {
    await localDataSource.saveProjects(items);
  }

  @override
  Future<void> clearLocalCache() async {
    await localDataSource.clearCache();
  }
}
