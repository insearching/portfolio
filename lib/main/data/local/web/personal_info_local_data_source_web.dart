import 'package:portfolio/core/logger/app_logger.dart';
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
  PersonalInfoLocalDataSourceWebImpl({
    required this.logger,
  });

  final AppLogger logger;

  // In-memory cache for web
  PersonalInfo? _cache;

  @override
  Future<void> cachePersonalInfo(PersonalInfo info) async {
    try {
      _cache = info;
      logger.debug('Personal info cached successfully in memory (web)',
          'PersonalInfoLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching personal info in memory', e, stackTrace,
          'PersonalInfoLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<PersonalInfo?> getCachedPersonalInfo() async {
    try {
      return _cache;
    } catch (e, stackTrace) {
      logger.error('Error getting cached personal info from memory', e,
          stackTrace, 'PersonalInfoLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache = null;
      logger.debug('Personal info cache cleared successfully (web)',
          'PersonalInfoLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error clearing personal info cache', e, stackTrace,
          'PersonalInfoLocalDataSourceWeb');
      rethrow;
    }
  }
}
