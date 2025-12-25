import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:sqflite/sqflite.dart';

/// Local static_data source for Posts
/// Handles all SQLite database operations for posts caching
abstract class PostsLocalDataSource {
  Future<void> cachePost(Post post);

  Future<void> cachePosts(List<Post> posts);

  Future<List<Post>> getCachedPosts();

  Future<void> clearCache();
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  PostsLocalDataSourceImpl({
    required this.database,
    required this.logger,
  });

  final Database database;
  final AppLogger logger;
  static const String _tableName = 'posts';
  static const String _tag = 'PostsLocalDataSource';

  @override
  Future<void> cachePost(Post post) async {
    try {
      await database.insert(
        _tableName,
        {
          'title': post.title,
          'description': post.description,
          'imageLink': post.imageLink,
          'link': post.link,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.debug('Post cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error('Error caching post in SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    try {
      final batch = database.batch();

      // Clear existing cache first
      batch.delete(_tableName);

      // Insert all posts
      for (final post in posts) {
        batch.insert(
          _tableName,
          {
            'title': post.title,
            'description': post.description,
            'imageLink': post.imageLink,
            'link': post.link,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      logger.debug('${posts.length} posts cached successfully in SQLite', _tag);
    } catch (e, stackTrace) {
      logger.error('Error caching posts in SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<List<Post>> getCachedPosts() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(_tableName);

      return List.generate(maps.length, (i) {
        return Post(
          title: maps[i]['title'] as String? ?? '',
          description: maps[i]['description'] as String? ?? '',
          imageLink: maps[i]['imageLink'] as String? ?? '',
          link: maps[i]['link'] as String? ?? '',
        );
      });
    } catch (e, stackTrace) {
      logger.error(
          'Error getting cached posts from SQLite', e, stackTrace, _tag);
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      logger.debug('Posts cache cleared successfully', _tag);
    } catch (e, stackTrace) {
      logger.error('Error clearing posts cache', e, stackTrace, _tag);
      rethrow;
    }
  }
}
