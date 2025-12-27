import 'package:flutter/material.dart';
import 'package:portfolio/main/di/service_locator.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
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
    super.key,
  });

  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String? link;

  @override
  Widget build(BuildContext context) {
    final deviceType = locator<DeviceInfo>().deviceType;

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          deviceType.isDesktop
              ? _DesktopDialogContent(
                  image: image,
                  title: title,
                  subtitle: subtitle,
                  description: description,
                  link: link,
                )
              : deviceType.isTablet
                  ? _TabletDialogContent(
                      image: image,
                      title: title,
                      subtitle: subtitle,
                      description: description,
                      link: link,
                    )
                  : _MobileDialogContent(
                      image: image,
                      title: title,
                      subtitle: subtitle,
                      description: description,
                      link: link,
                    ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: UIColors.accent,
                size: 28.0,
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: const EdgeInsets.all(8.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopDialogContent extends StatelessWidget {
  const _DesktopDialogContent({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.link,
  });

  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String? link;

  @override
  Widget build(BuildContext context) {
    const radius = 16.0;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 1000,
        maxHeight: 600,
      ),
      padding: const EdgeInsets.all(54.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (link != null) ...[
                    const SizedBox(height: 36),
                    RippleButton(
                      text: 'Check for more details',
                      onTap: () => launchUrlString(link!),
                    ),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TabletDialogContent extends StatelessWidget {
  const _TabletDialogContent({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.link,
  });

  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String? link;

  @override
  Widget build(BuildContext context) {
    const radius = 16.0;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 700,
      ),
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (link != null) ...[
              const SizedBox(height: 24),
              RippleButton(
                text: 'Check for more details',
                onTap: () => launchUrlString(link!),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MobileDialogContent extends StatelessWidget {
  const _MobileDialogContent({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.link,
  });

  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String? link;

  @override
  Widget build(BuildContext context) {
    const radius = 16.0;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.9,
        maxHeight: screenHeight * 0.85,
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (link != null) ...[
              const SizedBox(height: 20),
              RippleButton(
                text: 'Check for more details',
                onTap: () => launchUrlString(link!),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
