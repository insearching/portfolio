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
    return LayoutBuilder(
      builder: (context, constraints) {
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
                itemBuilder: (context, index) => _buildPostCard(widget.posts[index]),
              )
            : ListView.separated(
                itemCount: widget.posts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) => _buildPostCard(widget.posts[index]),
              ),
        );
      }
    );
  }

  Widget _buildPostCard(Post post) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 350,
      ),
      child: ElevatedContainer(
        onTap: () => launchUrlString(post.link),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
              ),
              Text(
                post.description,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: post.imageLink,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error, size: 150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
