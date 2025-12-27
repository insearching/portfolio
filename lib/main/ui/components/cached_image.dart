import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A generic widget for loading images from URLs or local assets with caching support.
///
/// Automatically detects whether the source is a URL or local asset path.
/// For URLs, uses [CachedNetworkImage] for efficient caching.
/// For local assets, uses standard [Image.asset].
class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
    super.key,
  });

  /// The image source - can be either a URL (http:// or https://) or local asset path
  final String imageUrl;

  /// The width of the image
  final double? width;

  /// The height of the image
  final double? height;

  /// How the image should be inscribed into the space allocated during layout
  final BoxFit fit;

  /// Color to blend with the image
  final Color? color;

  /// The blend mode to use when applying [color]
  final BlendMode? colorBlendMode;

  /// Widget displayed while the image is loading (only for network images)
  final Widget? placeholder;

  /// Widget displayed when the image fails to load
  final Widget? errorWidget;

  /// How to align the image within its bounds
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isUrl) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        placeholder: placeholder != null
            ? (context, url) => placeholder!
            : (context, url) => _buildDefaultPlaceholder(),
        errorWidget: errorWidget != null
            ? (context, url, error) => errorWidget!
            : (context, url, error) => _buildDefaultErrorWidget(),
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      errorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget!
          : (context, error, stackTrace) => _buildDefaultErrorWidget(),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return SizedBox(
      width: width ?? 32.0,
      height: height ?? 32.0,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return SizedBox(
      width: width ?? 32.0,
      height: height ?? 32.0,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      ),
    );
  }
}
