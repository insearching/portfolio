import 'package:equatable/equatable.dart';
import 'package:portfolio/main/domain/model/post.dart';

enum PostStatus { success, error, loading }

extension PostStatusX on PostStatus {
  bool get isSuccess => this == PostStatus.success;

  bool get isError => this == PostStatus.error;

  bool get isLoading => this == PostStatus.loading;
}

class BlogState extends Equatable {
  const BlogState({
    this.status = PostStatus.loading,
    List<Post>? posts,
  }) : posts = posts ?? const [];

  final List<Post> posts;
  final PostStatus status;

  @override
  List<Object?> get props => [status, posts];

  BlogState copyWith({
    List<Post>? posts,
    PostStatus? status,
  }) {
    return BlogState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
    );
  }
}
