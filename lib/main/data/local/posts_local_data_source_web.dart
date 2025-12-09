import 'package:portfolio/main/data/post.dart';

/// Web-compatible local data source for Posts
/// Uses in-memory caching since SQLite is not available on web
abstract class PostsLocalDataSourceWeb {
  Future<void> cachePost(Post post);

  Future<void> cachePosts(List<Post> posts);

  Future<List<Post>> getCachedPosts();

  Future<void> clearCache();
}

class PostsLocalDataSourceWebImpl implements PostsLocalDataSourceWeb {
  PostsLocalDataSourceWebImpl();

  // In-memory cache for web
  final List<Post> _cache = [];

  @override
  Future<void> cachePost(Post post) async {
    try {
      // Remove existing post with same title if exists
      _cache.removeWhere((p) => p.title == post.title);
      _cache.add(post);
      print('Post cached successfully in memory (web)');
    } catch (e) {
      print('Error caching post in memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    try {
      _cache.clear();
      _cache.addAll(posts);
      print('${posts.length} posts cached successfully in memory (web)');
    } catch (e) {
      print('Error caching posts in memory: $e');
      rethrow;
    }
  }

  @override
  Future<List<Post>> getCachedPosts() async {
    try {
      return List.from(_cache);
    } catch (e) {
      print('Error getting cached posts from memory: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _cache.clear();
      print('Posts cache cleared successfully (web)');
    } catch (e) {
      print('Error clearing posts cache: $e');
      rethrow;
    }
  }
}
