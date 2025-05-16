import 'package:flutter/material.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/ui/feature_content.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';

class DesktopFeatures extends StatelessWidget {
  const DesktopFeatures({
    required this.state,
    Key? key,
  }) : super(key: key);

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
          if (state.status.isSuccess)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.positions
                  .map(
                    (position) => Expanded(
                      child: FeatureContainer(
                        responsibility: Responsibility(
                          icon: position.icon,
                          title: position.title,
                          description: position.description,
                        ),
                        isPhone: false,
                      ),
                    ),
                  )
                  .toList(),
            )
        ],
      ),
    );
  }
}
