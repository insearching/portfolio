import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/feature_content.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';

class MobileFeatures extends StatelessWidget {
  const MobileFeatures({
    required this.state,
    super.key,
  });

  final PersonalInfoState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'What I Do',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 24.0),
          IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.positions
                  .map(
                    (position) => Expanded(
                      child: FeatureContainer(
                        position: position,
                        isPhone: true,
                      ),
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
