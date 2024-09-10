import 'package:flutter/material.dart';
import 'package:portfolio/utils/collections.dart';
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

enum NavigationMenu {
  home(name: 'Home', icon: 'assets/img/home.png'),
  features(name: 'Features', icon: 'assets/img/features.png'),
  portfolio(name: 'Portfolio', icon: 'assets/img/home.png'),
  resume(name: 'Resume', icon: 'assets/img/home.png'),
  clients(name: 'Clients', icon: 'assets/img/home.png'),
  pricing(name: 'pricing', icon: 'assets/img/home.png'),
  blog(name: 'blog', icon: 'assets/img/home.png'),
  contact(name: 'Contacts', icon: 'assets/img/home.png');

  final String name;
  final String icon;

  const NavigationMenu({required this.name, required this.icon});
}

enum Status {
  active(status: 'ACTIVE', subStatus: 'OPEN'),
  inactive(status: 'INACTIVE', subStatus: 'CLOSE');

  final String status;
  final String subStatus;

  const Status({required this.status, required this.subStatus});
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: isHovered ? const Color(0x15000000) : Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: NavigationMenu.values
                  .mapIndexed(
                    (menuItem, index) => IconLabel(
                      position: index,
                      selectedPosition: selectedPosition,
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
