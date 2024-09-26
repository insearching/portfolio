import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/ui/components/image_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Socials extends StatefulWidget {
  const Socials({
    required this.socials,
    super.key,
  });

  final List<SocialInfo> socials;

  @override
  State<Socials> createState() => _SocialsState();
}

class _SocialsState extends State<Socials> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children:
      widget.socials.map(
            (social) =>
            Padding(
              padding: const EdgeInsets.symmetric (horizontal: 8.0),
              child: ImageButton(
                icon: social.icon,
                onTap: () =>
                    launchUrl(
                      Uri.parse(social.url),
                    ),
              ),
            ),
      ).toList(),
    );
  }
}
