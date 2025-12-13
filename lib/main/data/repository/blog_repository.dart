import 'package:portfolio/main/data/local/sqlite/posts_local_data_source.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';
import 'package:portfolio/main/data/repository/base_repository.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';

/// Implementation of BlogRepository
/// Extends BaseRepository to leverage common 3-tier caching logic
class BlogRepositoryImpl
    extends BaseRepository<Post, PostsRemoteDataSource, PostsLocalDataSource>
    implements BlogRepository {
  BlogRepositoryImpl({
    required super.remoteDataSource,
    required super.localDataSource,
  });

  @override
  Future<void> addPost(Post post) async {
    try {
      // Add to remote first
      await remoteDataSource.addPost(post);

      // Then cache locally
      await localDataSource.cachePost(post);

      // Update memory cache if it exists
      updateMemoryCacheWithItem(post);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  /// Forces a refresh from remote, bypassing all caches
  /// For backward compatibility, returns the last value from the refresh stream
  @override
  Future<List<Post>> refreshPosts() async {
    return await refresh(entityName: 'posts').last;
  }

  /// Stream that emits posts progressively from cache layers
  /// Emits from: memory -> local -> remote
  @override
  Stream<List<Post>> get postsUpdateStream =>
      fetchWithCache(entityName: 'posts');

  // Implement abstract methods from BaseRepository

  @override
  Future<List<Post>> fetchFromRemote() async {
    return await remoteDataSource.readPosts();
  }

  @override
  Future<List<Post>> fetchFromLocal() async {
    return await localDataSource.getCachedPosts();
  }

  @override
  Future<void> saveToLocal(List<Post> items) async {
    await localDataSource.cachePosts(items);
  }

  @override
  Future<void> clearLocalCache() async {
    await localDataSource.clearCache();
  }
}
