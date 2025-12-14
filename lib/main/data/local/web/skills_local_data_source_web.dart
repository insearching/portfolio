import 'package:portfolio/main/data/skill.dart';

/// Web-compatible local data source for Skills
/// Uses in-memory caching since SQLite is not available on web
abstract class SkillsLocalDataSourceWeb {
  Future<void> cacheSkill(Skill skill);

  Future<void> cacheSkills(List<Skill> skills);

  Future<List<Skill>> getCachedSkills();

  Future<void> clearCache();
}

class SkillsLocalDataSourceWebImpl implements SkillsLocalDataSourceWeb {
  SkillsLocalDataSourceWebImpl();

  // In-memory cache for web
  final List<Skill> _cache = [];

  @override
  Future<void> cacheSkill(Skill skill) async {
    try {
      // Remove existing skill with same title if exists
      _cache.removeWhere((s) => s.title == skill.title);
      _cache.add(skill);
      print('Skill cached successfully in memory (web)');
    } catch (e) {
      print('Error caching skill in memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> cacheSkills(List<Skill> skills) async {
    try {
      _cache.clear();
      _cache.addAll(skills);
      print('${skills.length} skills cached successfully in memory (web)');
    } catch (e) {
      print('Error caching skills in memory: $e');
      rethrow;
    }
  }

  @override
  Future<List<Skill>> getCachedSkills() async {
    try {
      return List.from(_cache);
    } catch (e) {
      print('Error getting cached skills from memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      print('Skills cache cleared successfully (web)');
    } catch (e) {
      print('Error clearing skills cache: $e');
      rethrow;
    }
  }
}
