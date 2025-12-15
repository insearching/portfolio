import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/components/theme_toggle_button.dart';
import 'package:portfolio/main/ui/contact/socials.dart';
import 'package:portfolio/main/ui/menu/keys.dart';
import 'package:portfolio/main/ui/menu/navigation_panel.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_bloc.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_state.dart';
import 'package:portfolio/utils/constants.dart';

class DrawingMenu extends StatelessWidget {
  const DrawingMenu({
    super.key,
    this.onMenuItemSelected,
  });

  final VoidCallback? onMenuItemSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 8.0),
          const AnimatedThemeToggleButton(size: 24.0),
          const SizedBox(height: 8.0),
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
              // Call the callback to close drawer on mobile
              onMenuItemSelected?.call();
            },
          ),
          const HorizontalDivider(),
          const SizedBox(height: 24.0),
          BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, state) {
              if (state.status.isError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    state.errorMessage ?? 'Failed to load personal info',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.redAccent),
                  ),
                );
              }

              if (state.personalInfo == null) {
                // Show loading indicator while personal info is being loaded
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final socials = state.personalInfo!.socials;
              return Socials(socials: socials);
            },
          ),
        ],
      ),
    );
  }
}
