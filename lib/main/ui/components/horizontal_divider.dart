import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).dividerColor,
      height: 1.0,
      thickness: 1.0,
      indent: 0, //spacing at the start of divider
      endIndent: 0,
    );
  }
}
