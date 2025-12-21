import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/domain/model/social_info.dart';
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
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.socials
          .map(
            (social) => ImageButton(
              icon: social.icon,
              padding: const EdgeInsets.all(4.0),
              onTap: () => launchUrl(
                Uri.parse(social.url),
              ),
            ),
          )
          .toList(),
    );
  }
}
