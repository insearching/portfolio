import 'package:flutter/material.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/ui/blog_container.dart';

class TabletBlogWidget extends StatefulWidget {
  const TabletBlogWidget({
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Post> posts;

  @override
  State<TabletBlogWidget> createState() => _TabletBlogWidgetState();
}

class _TabletBlogWidgetState extends State<TabletBlogWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: widget.posts.length,
            itemBuilder: (context, index) => BlogContainer(
              post: widget.posts[index],
              horizontalPadding: 32.0,
              imageHeight: 220.0,
            ),
          ),
        );
      },
    );
  }
}
