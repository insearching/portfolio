import 'package:flutter/cupertino.dart';
import 'package:portfolio/utils/colors.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 1.0,
      width: size.width,
      color: UIColors.black,
    );
  }
}
