import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({
    required this.icon,
    required this.onTap,
    this.padding = const EdgeInsets.all(0),
    Key? key,
  }) : super(key: key);

  final String icon;
  final VoidCallback onTap;
  final EdgeInsets padding;

  @override
  State<ImageButton> createState() => ImageButtonState();
}

class ImageButtonState extends State<ImageButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultIconColor =
        Theme.of(context).iconTheme.color ?? UIColors.lightGrey;

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: widget.padding,
        child: ElevatedContainer(
          padding: const EdgeInsets.all(16.0),
          onElevatedChanged: (isElevated) {
            setState(() {
              isHovered = isElevated;
            });
          },
          onTap: widget.onTap,
          child: SizedBox(
            width: 20,
            height: 20,
            child: widget.icon.isNotEmpty
                ? Image.asset(
                    widget.icon,
                    color: isHovered ? UIColors.accent : defaultIconColor,
                    width: 20.0,
                    height: 20.0,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: 20.0,
                        color: isHovered ? UIColors.accent : defaultIconColor,
                      );
                    },
                  )
                : Icon(
                    Icons.image_not_supported,
                    size: 20.0,
                    color: isHovered ? UIColors.accent : defaultIconColor,
                  ),
          ),
        ),
      ),
    );
  }
}
