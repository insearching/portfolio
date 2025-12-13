import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/local/sqlite/education_local_data_source.dart';
import 'package:portfolio/main/data/remote/education_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';

/// Implementation of EducationRepository
/// Extends BaseRepository to leverage common 3-tier caching logic
class EducationRepositoryImpl extends BaseRepository<
    Education,
    EducationRemoteDataSource,
    EducationLocalDataSource> implements EducationRepository {
  EducationRepositoryImpl({
    required super.remoteDataSource,
    required super.localDataSource,
  });

  @override
  Future<List<Education>> readEducation() async {
    // For backward compatibility, return the last emitted value from the stream
    return await fetchWithCache(entityName: 'education').last;
  }

  /// Returns a Stream that emits education progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Education>> readEducationStream() {
    return fetchWithCache(entityName: 'education');
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  Future<List<Education>> refreshEducation() async {
    return await refresh(entityName: 'education').last;
  }

  /// Returns a Stream for refresh that emits fresh data
  Stream<List<Education>> refreshEducationStream() {
    return refresh(entityName: 'education');
  }

  /// Stream that notifies when education is updated from remote
  Stream<List<Education>> get educationUpdateStream => dataStream;

  // Implement abstract methods from BaseRepository

  @override
  Future<List<Education>> fetchFromRemote() async {
    return await remoteDataSource.readEducation();
  }

  @override
  Future<List<Education>> fetchFromLocal() async {
    return await localDataSource.getEducation();
  }

  @override
  Future<void> saveToLocal(List<Education> items) async {
    await localDataSource.saveEducationList(items);
  }

  @override
  Future<void> clearLocalCache() async {
    await localDataSource.clearCache();
  }
}
