import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';

class RippleButton extends StatefulWidget {
  const RippleButton({required this.text, Key? key}) : super(key: key);

  final String text;

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
            color: UIColors.backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: _isElevated
                ? [
                    const BoxShadow(
                      color: UIColors.black,
                      offset: Offset(10, 15),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: UIColors.black,
                      offset: Offset(10, 10),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: InkWell(
            onTap: () {},
            onHover: (value) {
              setState(() {
                _isElevated = value;
              });
            },
            child: Text(
              widget.text.toUpperCase(),
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}