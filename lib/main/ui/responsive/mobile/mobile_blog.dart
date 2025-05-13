import 'package:flutter/material.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/ui/blog_container.dart';

class MobileBlogWidget extends StatefulWidget {
  const MobileBlogWidget({
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Post> posts;

  @override
  State<MobileBlogWidget> createState() => _MobileBlogWidgetState();
}

class _MobileBlogWidgetState extends State<MobileBlogWidget> {
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.posts.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: BlogContainer(
                post: widget.posts[index],
                horizontalPadding: 16.0,
                imageHeight: 220.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
