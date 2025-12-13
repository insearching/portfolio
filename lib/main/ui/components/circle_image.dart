import 'package:flutter/cupertino.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({required this.imageAsset, required this.radius, Key? key})
      : super(key: key);

  final String imageAsset;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(radius), // Image radius
        child: imageAsset.isNotEmpty
            ? Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF424242),
                    child: const Icon(
                      CupertinoIcons.person_circle,
                      size: 64,
                    ),
                  );
                },
              )
            : Container(
                color: const Color(0xFF424242),
                child: const Icon(
                  CupertinoIcons.person_circle,
                  size: 64,
                ),
              ),
      ),
    );
  }
}
