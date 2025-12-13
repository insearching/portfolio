import 'package:portfolio/main/data/post.dart';
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
  });

  final Database database;
  static const String _tableName = 'posts';

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
      print('Post cached successfully in SQLite');
    } catch (e) {
      print('Error caching post in SQLite: $e');
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
      print('${posts.length} posts cached successfully in SQLite');
    } catch (e) {
      print('Error caching posts in SQLite: $e');
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
    } catch (e) {
      print('Error getting cached posts from SQLite: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await database.delete(_tableName);
      print('Posts cache cleared successfully');
    } catch (e) {
      print('Error clearing posts cache: $e');
      rethrow;
    }
  }
}
