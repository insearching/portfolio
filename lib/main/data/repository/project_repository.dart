import 'package:portfolio/main/data/local/sqlite/projects_local_data_source.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/data/remote/projects_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
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
  Future<List<Project>> readProjects() async {
    // For backward compatibility, return the last emitted value from the stream
    return await fetchWithCache(entityName: 'projects').last;
  }

  /// Returns a Stream that emits projects progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Project>> readProjectsStream() {
    return fetchWithCache(entityName: 'projects');
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  Future<List<Project>> refreshProjects() async {
    return await refresh(entityName: 'projects').last;
  }

  /// Returns a Stream for refresh that emits fresh data
  Stream<List<Project>> refreshProjectsStream() {
    return refresh(entityName: 'projects');
  }

  /// Stream that notifies when projects are updated from remote
  Stream<List<Project>> get projectsUpdateStream => dataStream;

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
