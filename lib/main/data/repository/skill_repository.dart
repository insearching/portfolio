import 'package:portfolio/main/data/local/sqlite/skills_local_data_source.dart';
import 'package:portfolio/main/data/remote/skills_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';

/// Implementation of SkillRepository
/// Extends BaseRepository to leverage common 3-tier caching logic
class SkillRepositoryImpl
    extends BaseRepository<Skill, SkillsRemoteDataSource, SkillsLocalDataSource>
    implements SkillRepository {
  SkillRepositoryImpl({
    required super.remoteDataSource,
    required super.localDataSource,
  });

  @override
  Future<void> addSkill(Skill skill) async {
    try {
      // Add to remote first
      await remoteDataSource.addSkill(skill);

      // Update memory cache if it exists
      updateMemoryCacheWithItem(skill);
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  @override
  Future<List<Skill>> refreshSkills() async {
    return await refresh(entityName: 'skills').last;
  }

  /// Stream that emits skills progressively from cache layers
  /// Emits from: memory -> local -> remote
  @override
  Stream<List<Skill>> get skillsUpdateStream =>
      fetchWithCache(entityName: 'skills');

  // Implement abstract methods from BaseRepository

  @override
  Future<List<Skill>> fetchFromRemote() async {
    return await remoteDataSource.readSkills();
  }

  @override
  Future<List<Skill>> fetchFromLocal() async {
    return await localDataSource.getSkills();
  }

  @override
  Future<void> saveToLocal(List<Skill> items) async {
    await localDataSource.saveSkills(items);
  }

  @override
  Future<void> clearLocalCache() async {
    await localDataSource.clearCache();
  }
}
