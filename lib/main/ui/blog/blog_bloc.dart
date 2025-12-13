import 'package:bloc/bloc.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/ui/blog/blog_event.dart';

import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc({
    required this.blogRepository,
  }) : super(const BlogState()) {
    on<GetPosts>(_mapGetPostsEventToState);
  }

  final BlogRepository blogRepository;

  void _mapGetPostsEventToState(GetPosts event, Emitter<BlogState> emit) async {
    emit(state.copyWith(status: PostStatus.loading));
    try {
      final posts = await blogRepository.readPosts();
      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: posts,
        ),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: PostStatus.error));
    }
  }
}
