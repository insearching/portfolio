import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class FeatureContainer extends StatelessWidget {
  const FeatureContainer({
    required this.position,
    required this.isPhone,
    super.key,
  });

  final Position position;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (position.icon.isNotEmpty)
                Image.asset(
                  position.icon,
                  color: UIColors.accent,
                  height: 32.0,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      size: 32.0,
                    );
                  },
                ),
              const SizedBox(width: 16.0),
              Flexible(
                child: Text(
                  position.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _FeatureBody(
            body: position.description,
            isScrollable: isPhone,
          )
        ],
      ),
    );
  }
}

class _FeatureBody extends StatefulWidget {
  const _FeatureBody({
    required this.body,
    required this.isScrollable,
  });

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
