import 'package:portfolio/main/data/local/posts_local_data_source.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/remote/posts_remote_data_source.dart';

/// Data Access Object for Posts
/// Handles both remote and local data operations with caching strategy
abstract class PostDao {
  Future<void> addPost(Post post);

  Future<List<Post>> readPosts();
}

class PostDaoImpl implements PostDao {
  PostDaoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;

  @override
  Future<void> addPost(Post post) async {
    try {
      // Add to remote first
      await remoteDataSource.addPost(post);

      // Then cache locally
      await localDataSource.cachePost(post);
    } catch (e) {
      print('Error in PostDao.addPost: $e');
      rethrow;
    }
  }

  @override
  Future<List<Post>> readPosts() async {
    try {
      // Try to fetch from remote
      final remotePosts = await remoteDataSource.readPosts();

      // Cache the remote data
      if (remotePosts.isNotEmpty) {
        await localDataSource.cachePosts(remotePosts);
      }

      return remotePosts;
    } catch (e) {
      print('Error fetching from remote, trying local cache: $e');

      // Fallback to local cache if remote fails
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        print('Returned ${cachedPosts.length} posts from local cache');
        return cachedPosts;
      } catch (cacheError) {
        print('Error reading from cache: $cacheError');
        return [];
      }
    }
  }
}
