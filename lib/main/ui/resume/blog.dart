import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BlogWidget extends StatefulWidget {
  const BlogWidget({
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Post> posts;

  @override
  State<BlogWidget> createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 800;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDesktop
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: widget.posts.length,
                itemBuilder: (context, index) =>
                    _buildPostCard(widget.posts[index]),
              )
            : ListView.separated(
                itemCount: widget.posts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16.0),
                itemBuilder: (context, index) =>
                    _buildPostCard(widget.posts[index]),
              ),
      );
    });
  }

  Widget _buildPostCard(Post post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 8.0 : 32.0;
    final imageHeight = screenWidth < 600 ? 120.0 : 220.0;
    final cardMaxHeight = screenWidth < 600 ? 250.0 : 350.0;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: cardMaxHeight,
      ),
      child: ElevatedContainer(
        onTap: () => launchUrlString(post.link),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                post.description,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: post.imageLink,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
