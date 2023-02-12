import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: UIColors.black,
      height: 1.0,
      thickness: 1.0,
      indent: 25, //spacing at the start of divider
      endIndent: 25,
    );
  }
}
