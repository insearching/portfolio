import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/feature_content.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';

class TabletFeatures extends StatelessWidget {
  const TabletFeatures({
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemCount: state.positions.length,
            itemBuilder: (context, index) => FeatureContainer(
              position: state.positions[index],
              isPhone: false,
            ),
          )
        ],
      ),
    );
  }
}
