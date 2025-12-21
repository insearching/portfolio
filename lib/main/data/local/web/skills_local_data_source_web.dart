import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Web-compatible local data source for Skills
/// Uses in-memory caching since SQLite is not available on web
abstract class SkillsLocalDataSourceWeb {
  Future<void> cacheSkill(Skill skill);

  Future<void> cacheSkills(List<Skill> skills);

  Future<List<Skill>> getCachedSkills();

  Future<void> clearCache();
}

class SkillsLocalDataSourceWebImpl implements SkillsLocalDataSourceWeb {
  final AppLogger logger;
  SkillsLocalDataSourceWebImpl({
    required this.logger,
  });

  // In-memory cache for web
  final List<Skill> _cache = [];

  @override
  Future<void> cacheSkill(Skill skill) async {
    try {
      // Remove existing skill with same title if exists
      _cache.removeWhere((s) => s.title == skill.title);
      _cache.add(skill);
      logger.debug('Skill cached successfully in memory (web)', 'SkillsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching skill in memory', e, stackTrace, 'SkillsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> cacheSkills(List<Skill> skills) async {
    try {
      _cache.clear();
      _cache.addAll(skills);
      logger.debug('${skills.length} skills cached successfully in memory (web)', 'SkillsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching skills in memory', e, stackTrace, 'SkillsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<List<Skill>> getCachedSkills() async {
    try {
      return List.from(_cache);
    } catch (e, stackTrace) {
      logger.error('Error getting cached skills from memory', e, stackTrace, 'SkillsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      logger.debug('Skills cache cleared successfully (web)', 'SkillsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error clearing skills cache', e, stackTrace, 'SkillsLocalDataSourceWeb');
      rethrow;
    }
  }
}
