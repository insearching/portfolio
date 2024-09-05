import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String icon;

  final VoidCallback onTap;

  @override
  State<ImageButton> createState() => ImageButtonState();
}

class ImageButtonState extends State<ImageButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      onElevatedChanged: (isElevated) {
        isHovered = isElevated;
      },
      onTap: widget.onTap,
      child: SizedBox(
        width: 20,
        height: 20,
        child: Image.asset(
          widget.icon,
          color: isHovered ? UIColors.accent : UIColors.lightGrey,
          width: 20.0,
          height: 20.0,
        ),
      ),
    );
  }
}