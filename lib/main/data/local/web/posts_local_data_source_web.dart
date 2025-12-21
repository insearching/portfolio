import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Web-compatible local static_data source for Posts
/// Uses in-memory caching since SQLite is not available on web
abstract class PostsLocalDataSourceWeb {
  Future<void> cachePost(Post post);

  Future<void> cachePosts(List<Post> posts);

  Future<List<Post>> getCachedPosts();

  Future<void> clearCache();
}

class PostsLocalDataSourceWebImpl implements PostsLocalDataSourceWeb {
  final AppLogger logger;
  PostsLocalDataSourceWebImpl({
    required this.logger,
  });

  // In-memory cache for web
  final List<Post> _cache = [];

  @override
  Future<void> cachePost(Post post) async {
    try {
      // Remove existing post with same title if exists
      _cache.removeWhere((p) => p.title == post.title);
      _cache.add(post);
      logger.debug('Post cached successfully in memory (web)', 'PostsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching post in memory', e, stackTrace, 'PostsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    try {
      _cache.clear();
      _cache.addAll(posts);
      logger.debug('${posts.length} posts cached successfully in memory (web)', 'PostsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error caching posts in memory', e, stackTrace, 'PostsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<List<Post>> getCachedPosts() async {
    try {
      return List.from(_cache);
    } catch (e, stackTrace) {
      logger.error('Error getting cached posts from memory', e, stackTrace, 'PostsLocalDataSourceWeb');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      logger.debug('Posts cache cleared successfully (web)', 'PostsLocalDataSourceWeb');
    } catch (e, stackTrace) {
      logger.error('Error clearing posts cache', e, stackTrace, 'PostsLocalDataSourceWeb');
      rethrow;
    }
  }
}
