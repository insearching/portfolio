import 'package:flutter/material.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/keys.dart';
import 'package:portfolio/main/ui/main_page.dart';
import 'package:portfolio/main/ui/navigation_panel.dart';
import 'package:portfolio/main/ui/socials.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavigationPanel(
            onMenuItemSelected: (position) {
              final tagKey = NavigationMenu.keyByPosition(position);
              if (tagKey == null) return;
              final context = keys[tagKey]?.currentContext;
              if (context == null) return;
              Scrollable.ensureVisible(
                context,
                duration: animationDuration,
              );
            },
          ),
          const HorizontalDivider(),
          const SizedBox(height: 24.0),
          Socials(socials: Repository.info.socials),
        ],
      ),
    );
  }
}
