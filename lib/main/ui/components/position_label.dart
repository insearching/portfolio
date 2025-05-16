import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';

class PositionLabel extends StatelessWidget {
  const PositionLabel({
    required this.state,
    super.key,
  });

  final PersonalInfoState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == PersonalInfoStatus.loading) {
      return const CircularProgressIndicator();
    } else if (state.status == PersonalInfoStatus.success) {
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
              animatedTexts: state.positions
                  .map(
                    (position) => TypewriterAnimatedText(
                      position.position,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                      speed: const Duration(milliseconds: 70),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Error'));
    }
  }
}
