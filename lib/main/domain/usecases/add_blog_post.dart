import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';

/// Use case for adding a new blog post
class AddBlogPost {
  AddBlogPost({required this.blogRepository});

  final BlogRepository blogRepository;

  /// Adds a new blog post after validation
  Future<void> call(Post post) async {
    _validatePost(post);

    try {
      await blogRepository.addPost(post);
    } catch (e) {
      throw Exception('Failed to add blog post: $e');
    }
  }

  /// Validates the post data before adding
  void _validatePost(Post post) {
    // Validate title
    if (post.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }

    // Validate description
    if (post.description.trim().isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }

    // Validate image link
    if (post.imageLink.trim().isEmpty) {
      throw ArgumentError('Image link cannot be empty');
    }
    if (!_isValidUrl(post.imageLink)) {
      throw ArgumentError('Image link must be a valid URL');
    }

    // Validate post link
    if (post.link.trim().isEmpty) {
      throw ArgumentError('Post link cannot be empty');
    }
    if (!_isValidUrl(post.link)) {
      throw ArgumentError('Post link must be a valid URL');
    }
  }

  /// Checks if a string is a valid URL
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
}
