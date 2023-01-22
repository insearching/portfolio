import 'package:flutter/material.dart';
import 'package:portfolio/main/components/circle_image.dart';
import 'package:portfolio/utils/colors.dart';

class NavigationPanel extends StatelessWidget {
  const NavigationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration:
                const BoxDecoration(color: UIColors.darkGrey, shape: BoxShape.circle),
            child: const CircleImage(
              imageAsset: 'assets/img/avatar.jpg',
              radius: 70,
            ),
          ),
          const SizedBox(height: 60.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              IconLabel(assetName: 'assets/img/home.png', text: 'Home', ),
              IconLabel(assetName: 'assets/img/features.png', text: 'Features'),
              IconLabel(assetName: 'assets/img/home.png', text: 'Portfolio'),
              IconLabel(assetName: 'assets/img/home.png', text: 'Resume'),
              IconLabel(assetName: 'assets/img/home.png', text: 'Clients'),
              IconLabel(assetName: 'assets/img/home.png', text: 'Pricing'),
              IconLabel(assetName: 'assets/img/home.png', text: 'Blog'),
              IconLabel(assetName: 'assets/img/home.png', text: 'Contact'),
            ],
          )
        ],
      ),
    );
  }
}

class IconLabel extends StatefulWidget {
  const IconLabel({required this.assetName, required this.text, required this.onPressed, Key? key})
      : super(key: key);

  final String assetName;

  final String text;

  final ((Int) -> Void) onPressed;

  @override
  State<IconLabel> createState() => _IconLabelState();
}

class _IconLabelState extends State<IconLabel> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.asset(
            widget.assetName,
            color: _isHovered ? UIColors.accent : UIColors.lightGrey,
            width: 20.0,
            height: 20.0,
          ),
          const SizedBox(width: 16.0),
          InkWell(
            onTap: () {},
            onHover: (value) {
              setState(() {
                _isHovered = value;
              });
            },
            child: Text(
              widget.text.toUpperCase(),
              style: _isHovered
                  ? Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(color: UIColors.accent)
                  : Theme.of(context).textTheme.headline2,
            ),
          ),
        ],
      ),
    );
  }
}
