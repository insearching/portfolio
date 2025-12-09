import 'package:flutter/material.dart';
import 'package:portfolio/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: themeProvider.isDarkMode
                ? Colors.yellow.shade700
                : Colors.indigo.shade900,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
          tooltip: themeProvider.isDarkMode
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
        );
      },
    );
  }
}

/// A more styled version with animation
/// Only shows when system theme is not available
class AnimatedThemeToggleButton extends StatelessWidget {
  final double size;

  const AnimatedThemeToggleButton({
    Key? key,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Only show if not in system mode
        if (themeProvider.isSystemMode) {
          return const SizedBox.shrink();
        }

        return InkWell(
          onTap: () {
            themeProvider.toggleTheme();
          },
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            padding: EdgeInsets.all(size / 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                key: ValueKey<bool>(themeProvider.isDarkMode),
                size: size,
                color: themeProvider.isDarkMode
                    ? Colors.yellow.shade700
                    : Colors.indigo.shade900,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A switch-style theme toggle
class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dark_mode_outlined,
              size: 20,
              color: themeProvider.isDarkMode
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            Switch(
              value: !themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
              activeTrackColor: Colors.indigo.shade900,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.light_mode_outlined,
              size: 20,
              color: !themeProvider.isDarkMode
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.5),
            ),
          ],
        );
      },
    );
  }
}
