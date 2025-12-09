import 'package:flutter/material.dart';

class RippleButton extends StatefulWidget {
  const RippleButton({
    required this.text,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;

  final VoidCallback? onTap;

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton> {
  bool _isElevated = false;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _isElevated ? const Offset(0, -1) : const Offset(0, 0),
      child: Transform.scale(
        scale: _isElevated ? 1.06 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: _isElevated
                ? [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      offset: const Offset(10, 15),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.2),
                      offset: const Offset(10, 10),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: InkWell(
            onTap: () {
              widget.onTap?.call();
            },
            onHover: (value) {
              setState(() {
                _isElevated = value;
              });
            },
            child: Text(
              textAlign: TextAlign.center,
              widget.text.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}
