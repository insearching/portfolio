import 'package:portfolio/main/data/local/dao/post_dao.dart';
import 'package:portfolio/main/data/post.dart';

/// Repository for managing blog posts
/// Provides business logic layer between UI and data access
class BlogRepository {
  BlogRepository({
    required this.postDao,
  });

  final PostDao postDao;

  Future<void> addPost(Post post) async {
    try {
      await postDao.addPost(post);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  Future<List<Post>> readPosts() async {
    try {
      return await postDao.readPosts();
    } catch (e) {
      throw Exception('Failed to read posts: $e');
    }
  }
}
