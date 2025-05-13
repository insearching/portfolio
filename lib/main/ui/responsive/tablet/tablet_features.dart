import 'package:flutter/material.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/ui/feature_content.dart';

class TabletFeatures extends StatefulWidget {
  const TabletFeatures({
    required this.responsibilities,
    Key? key,
  }) : super(key: key);

  final List<Responsibility> responsibilities;

  @override
  State<TabletFeatures> createState() => _TabletFeaturesState();
}

class _TabletFeaturesState extends State<TabletFeatures> {
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
            ),
            itemCount: widget.responsibilities.length,
            itemBuilder: (context, index) => FeatureContainer(
              responsibility: widget.responsibilities[index],
              isPhone: false,
            ),
          )
        ],
      ),
    );
  }
}
