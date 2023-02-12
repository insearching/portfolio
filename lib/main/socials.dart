import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/components/elevated_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';

class Socials extends StatelessWidget {
  const Socials({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SocialButton(
          icon: 'assets/img/facebook.png',
          onTap: () => launchUrl(
            Uri.parse('https://www.facebook.com/insearching1234'),
          ),
        ),
        _SocialButton(
          icon: 'assets/img/linkedin.png',
          onTap: () => launchUrl(
            Uri.parse('https://www.linkedin.com/in/serhii-hrabas/'),
          ),
        ),
        _SocialButton(
          icon: 'assets/img/twitter.png',
          onTap: () => launchUrl(
            Uri.parse('https://twitter.com/HrabasSerhii'),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String icon;

  final VoidCallback onTap;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      onElevatedChanged: (isElevated) {
        isHovered = isElevated;
      },
      onTap: widget.onTap,
      child: SizedBox(
        width: 20,
        height: 20,
        child: Image.asset(
          widget.icon,
          color: isHovered ? UIColors.accent : UIColors.lightGrey,
          width: 20.0,
          height: 20.0,
        ),
      ),
    );
  }
}
