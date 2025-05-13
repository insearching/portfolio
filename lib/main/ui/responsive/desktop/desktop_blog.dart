import 'package:flutter/material.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/ui/blog_container.dart';

class DesktopBlogWidget extends StatefulWidget {
  const DesktopBlogWidget({
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Post> posts;

  @override
  State<DesktopBlogWidget> createState() => _DesktopBlogWidgetState();
}

class _DesktopBlogWidgetState extends State<DesktopBlogWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          Text(
            'Blog',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: widget.posts.length,
            itemBuilder: (context, index) => BlogContainer(
              post: widget.posts[index],
              horizontalPadding: 32.0,
              imageHeight: 220.0,
            ),
          ),
        ],
      ),
    );
  }
}
