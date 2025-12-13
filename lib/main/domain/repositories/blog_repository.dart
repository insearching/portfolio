import 'package:portfolio/main/data/post.dart';

/// Repository interface for managing blog posts
/// Defines the contract for blog post static_data operations
abstract class BlogRepository {
  /// Adds a new post to the blog
  Future<void> addPost(Post post);

  /// Fetches posts from remote source and caches them locally
  /// Falls back to local cache if remote fetch fails
  Future<List<Post>> readPosts();
}
