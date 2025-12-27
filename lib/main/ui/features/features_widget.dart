import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/ui/features/feature_content.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';
import 'package:provider/provider.dart';

class FeaturesWidget extends StatelessWidget {
  const FeaturesWidget({
    required this.state,
    super.key,
  });

  final PersonalInfoState state;

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
          if (state.status.isSuccess)
            deviceType.isPhone
                ? IntrinsicHeight(
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
                : deviceType.isDesktop
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.positions
                            .map(
                              (position) => Expanded(
                                child: FeatureContainer(
                                  position: position,
                                  isPhone: false,
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
