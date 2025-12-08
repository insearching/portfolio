import 'package:equatable/equatable.dart';

/// Base class for blog events
/// Using sealed class pattern for exhaustive event handling
sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load blog posts
class GetPosts extends BlogEvent {
  const GetPosts();
}
