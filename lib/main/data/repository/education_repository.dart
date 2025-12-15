import 'package:portfolio/main/data/local/sqlite/education_local_data_source.dart';
import 'package:portfolio/main/data/remote/education_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/domain/model/education.dart';
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

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  @override
  Future<List<Education>> refreshEducation() async {
    return await refresh(entityName: 'education').last;
  }

  /// Stream that emits education progressively from cache layers
  /// Emits from: memory -> local -> remote
  @override
  Stream<List<Education>> get educationUpdateStream =>
      fetchWithCache(entityName: 'education');

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
