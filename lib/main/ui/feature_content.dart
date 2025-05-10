import 'package:flutter/material.dart';
import 'package:portfolio/main/data/responsibility.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class FeatureContainer extends StatefulWidget {
  const FeatureContainer({
    required this.responsibility,
    required this.isPhone,
    Key? key,
  }) : super(key: key);

  final Responsibility responsibility;
  final bool isPhone;

  @override
  State<FeatureContainer> createState() => _FeatureContainerState();
}

class _FeatureContainerState extends State<FeatureContainer> {
  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  widget.responsibility.icon,
                  color: UIColors.accent,
                  height: 32.0,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(width: 16.0),
                Text(
                  widget.responsibility.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            _FeatureBody(
              body: widget.responsibility.description,
              isScrollable: widget.isPhone,
            )
          ],
        ),
      ),
    );
  }
}

class _FeatureBody extends StatefulWidget {
  const _FeatureBody({
    required this.body,
    required this.isScrollable,
    Key? key,
  }) : super(key: key);

  final String body;
  final bool isScrollable;

  @override
  State<_FeatureBody> createState() => _FeatureBodyState();
}

class _FeatureBodyState extends State<_FeatureBody> {
  @override
  Widget build(BuildContext context) {
    return widget.isScrollable
        ? Flexible(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Text(
          widget.body,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    )
        : Text(
      widget.body,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}