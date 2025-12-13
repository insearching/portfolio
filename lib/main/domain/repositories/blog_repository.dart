import 'package:portfolio/main/data/post.dart';

/// Repository interface for managing blog posts
/// Defines the contract for blog post static_data operations
abstract class BlogRepository {
  /// Adds a new post to the blog
  Future<void> addPost(Post post);

  /// Forces a refresh from remote, bypassing all caches
  Future<List<Post>> refreshPosts();

  /// Stream that emits posts progressively from cache layers
  /// Emits from: memory -> local -> remote
  Stream<List<Post>> get postsUpdateStream;
}
