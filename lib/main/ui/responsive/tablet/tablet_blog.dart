import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/blog/blog_container.dart';
import 'package:portfolio/main/ui/blog/blog_state.dart';

class TabletBlogWidget extends StatelessWidget {
  const TabletBlogWidget({
    required this.blogState,
    Key? key,
  }) : super(key: key);

  final BlogState blogState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Text(
            'Blog',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          if (blogState.status == PostStatus.loading)
            const CircularProgressIndicator()
          else if (blogState.status == PostStatus.error)
            Center(
              child: Text(
                'Error loading posts',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            )
          else if (blogState.status == PostStatus.success)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: blogState.posts.length,
              itemBuilder: (context, index) => BlogContainer(
                post: blogState.posts[index],
                horizontalPadding: 32.0,
                imageHeight: 220.0,
              ),
            ),
        ],
      ),
    );
  }
}
