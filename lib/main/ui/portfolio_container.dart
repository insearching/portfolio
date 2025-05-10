import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';

import 'components/elevated_container.dart';

class PortfolioContainer extends StatefulWidget {
  const PortfolioContainer({
    required this.image,
    required this.title,
    required this.onTap,
    this.showArrow = false,
    Key? key,
  }) : super(key: key);

  final String image;
  final String title;
  final bool showArrow;
  final VoidCallback onTap;

  @override
  State<PortfolioContainer> createState() => _PortfolioContainerState();
}

class _PortfolioContainerState extends State<PortfolioContainer> {
  bool _isArrowVisible = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      onTap: widget.onTap,
      onElevatedChanged: (value) {
        setState(() {
          _isArrowVisible = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.asset(
                    widget.image,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.showArrow)
              Opacity(
                opacity: _isArrowVisible ? 1.0 : 0.0,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.0),
                    Icon(
                      Icons.arrow_forward,
                      size: 40.0,
                      color: UIColors.accent,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
