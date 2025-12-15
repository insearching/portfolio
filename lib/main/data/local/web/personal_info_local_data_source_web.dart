import 'package:portfolio/main/domain/model/personal_info.dart';

/// Web-compatible local data source for PersonalInfo
/// Uses in-memory caching since SQLite is not available on web
abstract class PersonalInfoLocalDataSourceWeb {
  Future<void> cachePersonalInfo(PersonalInfo info);

  Future<PersonalInfo?> getCachedPersonalInfo();

  Future<void> clearCache();
}

class PersonalInfoLocalDataSourceWebImpl
    implements PersonalInfoLocalDataSourceWeb {
  PersonalInfoLocalDataSourceWebImpl();

  // In-memory cache for web
  PersonalInfo? _cache;

  @override
  Future<void> cachePersonalInfo(PersonalInfo info) async {
    try {
      _cache = info;
      print('Personal info cached successfully in memory (web)');
    } catch (e) {
      print('Error caching personal info in memory: $e');
      rethrow;
    }
  }

  @override
  Future<PersonalInfo?> getCachedPersonalInfo() async {
    try {
      return _cache;
    } catch (e) {
      print('Error getting cached personal info from memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache = null;
      print('Personal info cache cleared successfully (web)');
    } catch (e) {
      print('Error clearing personal info cache: $e');
      rethrow;
    }
  }
}
