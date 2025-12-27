import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/ui/components/cached_image.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BlogContainer extends StatelessWidget {
  const BlogContainer({
    required this.post,
    required this.horizontalPadding,
    required this.imageHeight,
    super.key,
  });

  final Post post;
  final double horizontalPadding;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      padding:
          EdgeInsets.symmetric(vertical: 16, horizontal: horizontalPadding),
      onTap: () => launchUrlString(post.link),
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
          const SizedBox(height: 8.0),
          Text(
            post.description,
            style: Theme.of(context).textTheme.bodyMedium,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          if (post.imageLink.isNotEmpty)
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedImage(
                  imageUrl: post.imageLink,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: const Center(child: CircularProgressIndicator()),
                  errorWidget: const Icon(Icons.error, size: 150),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
