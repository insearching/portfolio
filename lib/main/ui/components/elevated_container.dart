import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/elevated_container_theme.dart';

class ElevatedContainer extends StatefulWidget {
  const ElevatedContainer({
    required this.child,
    this.onElevatedChanged,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    super.key,
  });

  final Widget child;
  final ValueChanged<bool>? onElevatedChanged;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  State<ElevatedContainer> createState() => _ElevatedContainerState();
}

class _ElevatedContainerState extends State<ElevatedContainer> {
  bool _isElevated = false;

  @override
  Widget build(BuildContext context) {
    // Get the theme, with fallback to dark theme
    final theme = Theme.of(context).extension<ElevatedContainerTheme>() ??
        ElevatedContainerTheme.dark;

    return AnimatedContainer(
      duration: theme.animationDuration,
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: _isElevated
            ? LinearGradient(
                colors: theme.gradientColorsElevated,
                begin: theme.gradientBeginElevated,
                end: theme.gradientEndElevated,
              )
            : LinearGradient(
                colors: theme.gradientColorsNormal,
                begin: theme.gradientBeginNormal,
                end: theme.gradientEndNormal,
              ),
        borderRadius: BorderRadius.circular(theme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColorLight,
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: theme.shadowColorDark,
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: widget.onTap != null
          ? _PressedWidget(
              onTap: widget.onTap!,
              onElevatedChanged: ((elevated) => {
                    _isElevated = elevated,
                    widget.onElevatedChanged?.call(elevated)
                  }),
              child: widget.child,
            )
          : InkWell(
              onHover: (value) {
                setState(() {
                  _isElevated = value;
                  widget.onElevatedChanged?.call(value);
                });
              },
              child: widget.child,
            ),
    );
  }
}

class _PressedWidget extends StatefulWidget {
  const _PressedWidget({
    required this.child,
    required this.onTap,
    this.onElevatedChanged,
  });

  final Widget child;
  final VoidCallback onTap;
  final ValueChanged<bool>? onElevatedChanged;

  @override
  State<_PressedWidget> createState() => _PressedWidgetState();
}

class _PressedWidgetState extends State<_PressedWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) {
        setState(() {
          widget.onElevatedChanged?.call(value);
        });
      },
      child: widget.child,
    );
  }
}
