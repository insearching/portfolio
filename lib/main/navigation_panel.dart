import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({
    required this.onMenuItemSelected,
    Key? key,
  }) : super(key: key);

  final ValueChanged<int> onMenuItemSelected;

  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  int? selectedPosition;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    onMenuItemSelect(position) {
      widget.onMenuItemSelected(position);
      setState(() {
        selectedPosition = position;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            onHover: (value) {
              setState(() {
                isHovered = value;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: isHovered ? const Color(0x15000000) : Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconLabel(
                    position: 0,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Home',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 1,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/features.png',
                    text: 'Features',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 2,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Portfolio',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 3,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Resume',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 4,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Clients',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 5,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Pricing',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 6,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Blog',
                    onPressed: onMenuItemSelect,
                  ),
                  IconLabel(
                    position: 7,
                    selectedPosition: selectedPosition,
                    assetName: 'assets/img/home.png',
                    text: 'Contact',
                    onPressed: onMenuItemSelect,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IconLabel extends StatefulWidget {
  const IconLabel({
    required this.position,
    required this.selectedPosition,
    required this.assetName,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final int position;

  final int? selectedPosition;

  final String assetName;

  final String text;

  final ValueChanged<int> onPressed;

  @override
  State<IconLabel> createState() => _IconLabelState();
}

class _IconLabelState extends State<IconLabel> {
  bool isHovered = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final int position = widget.position;
    isSelected = (widget.selectedPosition ?? -1) == position;
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                widget.onPressed(position);
                setState(() {
                  isSelected = true;
                });
              },
              onHover: (value) {
                setState(() {
                  isHovered = value;
                });
              },
              child: Row(
                children: [
                  Image.asset(
                    widget.assetName,
                    color: isHovered || isSelected ? UIColors.accent : UIColors.lightGrey,
                    width: 20.0,
                    height: 20.0,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    widget.text.toUpperCase(),
                    style: isHovered || isSelected
                        ? Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: UIColors.accent)
                        : Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
            )),
      ],
    );
  }
}
