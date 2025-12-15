import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';

/// Use case for adding a new blog post
class AddBlogPost {
  AddBlogPost({required this.blogRepository});

  final BlogRepository blogRepository;

  /// Adds a new blog post
  Future<void> call(Post post) async {
    try {
      await blogRepository.addPost(post);
    } catch (e) {
      throw Exception('Failed to add blog post: $e');
    }
  }
}
