import 'package:portfolio/main/data/education.dart';

/// Web-compatible local data source for Education
/// Uses in-memory caching since SQLite is not available on web
abstract class EducationLocalDataSourceWeb {
  Future<void> cacheEducation(Education education);

  Future<void> cacheEducationList(List<Education> educationList);

  Future<List<Education>> getCachedEducation();

  Future<void> clearCache();
}

class EducationLocalDataSourceWebImpl implements EducationLocalDataSourceWeb {
  EducationLocalDataSourceWebImpl();

  // In-memory cache for web
  final List<Education> _cache = [];

  @override
  Future<void> cacheEducation(Education education) async {
    try {
      // Remove existing education record with same title if exists
      _cache.removeWhere((e) => e.title == education.title);
      _cache.add(education);
      print('Education record cached successfully in memory (web)');
    } catch (e) {
      print('Error caching education record in memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> cacheEducationList(List<Education> educationList) async {
    try {
      _cache.clear();
      _cache.addAll(educationList);
      print(
          '${educationList.length} education records cached successfully in memory (web)');
    } catch (e) {
      print('Error caching education records in memory: $e');
      rethrow;
    }
  }

  @override
  Future<List<Education>> getCachedEducation() async {
    try {
      return List.from(_cache);
    } catch (e) {
      print('Error getting cached education records from memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      print('Education cache cleared successfully (web)');
    } catch (e) {
      print('Error clearing education cache: $e');
      rethrow;
    }
  }
}
