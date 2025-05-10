import 'package:flutter/material.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/ui/feature_content.dart';

class MobileFeatures extends StatefulWidget {
  const MobileFeatures({
    required this.responsibilities,
    Key? key,
  }) : super(key: key);

  final List<Responsibility> responsibilities;

  @override
  State<MobileFeatures> createState() => _MobileFeaturesState();
}

class _MobileFeaturesState extends State<MobileFeatures> {
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
              children: widget.responsibilities
                  .map(
                    (responsibility) => Expanded(
                      child: FeatureContainer(
                        responsibility: responsibility,
                        isPhone: false,
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
