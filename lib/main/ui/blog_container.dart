import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BlogContainer extends StatelessWidget {
  const BlogContainer({
    required this.post,
    required this.horizontalPadding,
    required this.imageHeight,
    Key? key,
  }) : super(key: key);

  final Post post;
  final double horizontalPadding;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      onTap: () => launchUrlString(post.link),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            Text(
              post.description,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16.0),
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
    );
  }
}
