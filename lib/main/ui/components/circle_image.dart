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
        child: Image.asset(imageAsset, fit: BoxFit.cover),
      ),
    );
  }
}
