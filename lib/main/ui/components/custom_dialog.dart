import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.link,
    Key? key,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String? link;

  @override
  Widget build(BuildContext context) {
    final mLink = link;
    const radius = 16.0;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      contentPadding: const EdgeInsets.all(54.0),
      backgroundColor: UIColors.backgroundColor,
      content: SingleChildScrollView(
        child: SizedBox(
          width: 1000,
          height: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.asset(
                  image,
                  height: 400,
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    if (mLink != null) ...[
                      const SizedBox(height: 36),
                      RippleButton(
                        text: 'Open in Google Play',
                        onTap: () => launchUrlString(mLink),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
