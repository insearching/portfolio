import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';

/// Use case for getting posts stream
/// Returns a Stream that emits posts progressively from cache layers
/// Emits from: memory -> local -> remote
class GetPostsStream {
  const GetPostsStream({required this.blogRepository});

  final BlogRepository blogRepository;

  Stream<List<Post>> call() {
    try {
      return blogRepository.postsUpdateStream;
    } catch (e) {
      throw Exception('Failed to load posts stream: $e');
    }
  }
}
