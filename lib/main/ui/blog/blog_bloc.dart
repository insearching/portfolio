import 'package:bloc/bloc.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/ui/blog/blog_event.dart';

import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc({
    required this.blogRepository,
    required this.logger,
  }) : super(const BlogState()) {
    on<GetPosts>(_mapGetPostsEventToState);
  }

  final BlogRepository blogRepository;
  final AppLogger logger;

  void _mapGetPostsEventToState(GetPosts event, Emitter<BlogState> emit) async {
    emit(state.copyWith(status: PostStatus.loading));
    try {
      final posts = await blogRepository.postsUpdateStream.last;
      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: posts,
        ),
      );
    } catch (error, stacktrace) {
      logger.error('Error fetching posts', error, stacktrace, 'BlogBloc');
      emit(state.copyWith(status: PostStatus.error));
    }
  }
}
