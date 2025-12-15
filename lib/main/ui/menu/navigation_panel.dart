import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/ui/menu/navigation_menu.dart';
import 'package:portfolio/utils/collections.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:provider/provider.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({
    required this.onMenuItemSelected,
    super.key,
  });

  final ValueChanged<int> onMenuItemSelected;

  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSmallDevice = context.read<DeviceInfo>().deviceType.isSmallDevice;

    onMenuItemSelect(position) {
      widget.onMenuItemSelected(position);
    }

    return Padding(
      padding: EdgeInsets.all(isSmallDevice ? 16.0 : 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color:
                    isHovered ? const Color(0x15000000) : Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: NavigationMenu.values
                  .mapIndexed(
                    (menuItem, index) => IconLabel(
                      position: index,
                      assetName: menuItem.icon,
                      text: menuItem.name,
                      onPressed: onMenuItemSelect,
                    ),
                  )
                  .toList(),
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
    required this.assetName,
    required this.text,
    required this.onPressed,
    super.key,
  });

  final int position;
  final String assetName;
  final String text;
  final ValueChanged<int> onPressed;

  @override
  State<IconLabel> createState() => _IconLabelState();
}

class _IconLabelState extends State<IconLabel> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final int position = widget.position;
    final defaultIconColor =
        Theme.of(context).iconTheme.color ?? UIColors.lightGrey;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              widget.onPressed(position);
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
                  color: isHovered ? UIColors.accent : defaultIconColor,
                  width: 20.0,
                  height: 20.0,
                ),
                const SizedBox(width: 16.0),
                Text(
                  widget.text.toUpperCase(),
                  style: isHovered
                      ? Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: UIColors.accent)
                      : Theme.of(context).textTheme.displayMedium,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
