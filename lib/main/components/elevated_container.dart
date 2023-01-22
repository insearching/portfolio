import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';

class ElevatedContainer extends StatefulWidget {
  const ElevatedContainer({
    required this.child,
    required this.onElevatedChanged,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final ValueChanged<bool> onElevatedChanged;

  @override
  State<ElevatedContainer> createState() => _ElevatedContainerState();
}

class _ElevatedContainerState extends State<ElevatedContainer> {
  bool _isElevated = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        gradient: _isElevated
            ? const LinearGradient(
                colors: [
                  UIColors.backgroundColorDark,
                  UIColors.backgroundColorDark,
                  UIColors.backgroundColorDark,
                  UIColors.backgroundColorDark,
                  UIColors.backgroundColorLight,
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              )
            : const LinearGradient(
                colors: [
                  UIColors.backgroundColorDark,
                  Color(0xFF1D1F22),
                  Color(0xFF1D2021),
                  Color(0xFF1D2020),
                  UIColors.backgroundColorLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF313135),
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xDE161515),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          setState(() {
            _isElevated = value;
            widget.onElevatedChanged(value);
          });
        },
        child: _isElevated ? widget.child : widget.child,
      ),
    );
  }
}
