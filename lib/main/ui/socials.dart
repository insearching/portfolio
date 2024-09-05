import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/components/image_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Socials extends StatelessWidget {
  const Socials({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageButton(
          icon: 'assets/img/facebook.png',
          onTap: () => launchUrl(
            Uri.parse('https://www.facebook.com/insearching1234'),
          ),
        ),
        const SizedBox(width: 8.0),
        ImageButton(
          icon: 'assets/img/linkedin.png',
          onTap: () => launchUrl(
            Uri.parse('https://www.linkedin.com/in/serhii-hrabas/'),
          ),
        ),
        const SizedBox(width: 8.0),
        ImageButton(
          icon: 'assets/img/twitter.png',
          onTap: () => launchUrl(
            Uri.parse('https://twitter.com/HrabasSerhii'),
          ),
        ),
      ],
    );
  }
}
