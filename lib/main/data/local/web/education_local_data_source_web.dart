import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/domain/model/education.dart';

/// Web-compatible local data source for Education
/// Uses in-memory caching since SQLite is not available on web
abstract class EducationLocalDataSourceWeb {
  Future<void> cacheEducation(Education education);

  Future<void> cacheEducationList(List<Education> educationList);

  Future<List<Education>> getCachedEducation();

  Future<void> clearCache();
}

class EducationLocalDataSourceWebImpl implements EducationLocalDataSourceWeb {
  final AppLogger logger;
  EducationLocalDataSourceWebImpl({
    required this.logger,
  });

  // In-memory cache for web
  final List<Education> _cache = [];

  @override
  Future<void> cacheEducation(Education education) async {
    try {
      // Remove existing education record with same title if exists
      _cache.removeWhere((e) => e.title == education.title);
      _cache.add(education);
      logger.debug('Education record cached successfully in memory (web)',
          'EducationLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching education record in memory', e, stackTrace,
          'EducationLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> cacheEducationList(List<Education> educationList) async {
    try {
      _cache.clear();
      _cache.addAll(educationList);
      logger.debug(
          '${educationList.length} education records cached successfully in memory (web)',
          'EducationLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching education records in memory', e, stackTrace,
          'EducationLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<List<Education>> getCachedEducation() async {
    try {
      return List.from(_cache);
    } catch (e, stackTrace) {
      logger.error('Error getting cached education records from memory', e,
          stackTrace, 'EducationLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      logger.debug('Education cache cleared successfully (web)',
          'EducationLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error clearing education cache', e, stackTrace,
          'EducationLocalDataSourceWeb');
      rethrow;
    }
  }
}
