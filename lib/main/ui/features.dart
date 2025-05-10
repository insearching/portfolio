import 'package:flutter/material.dart';
import 'package:portfolio/main/data/device_info.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/ui/feature_content.dart';
import 'package:provider/provider.dart';

class Features extends StatefulWidget {
  const Features({
    required this.responsibilities,
    Key? key,
  }) : super(key: key);

  final List<Responsibility> responsibilities;

  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  @override
  Widget build(BuildContext context) {
    final deviceType = context.read<DeviceInfo>().deviceType;
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
          deviceType.isLargeScreen
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                )
              : IntrinsicHeight(
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
