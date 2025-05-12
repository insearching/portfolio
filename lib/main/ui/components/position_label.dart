import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class PositionLabel extends StatelessWidget {
  const PositionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> positions = [
      'Senior Android developer',
      'Flutter developer',
      'KMP developer'
    ];
    return SizedBox(
      height: 130.0,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'I am a ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AnimatedTextKit(
            repeatForever: true,
            animatedTexts: positions
                .map(
                  (position) => TypewriterAnimatedText(
                    position,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    speed: const Duration(milliseconds: 70),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
