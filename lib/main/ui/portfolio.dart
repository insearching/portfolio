import 'package:flutter/material.dart';
import 'package:portfolio/main/data/device_info.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/ui/components/custom_dialog.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:provider/provider.dart';

import '../data/device_type.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({
    required this.projects,
    super.key,
  });

  final List<Project> projects;

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    final deviceType = context.read<DeviceInfo>().deviceType;
    final isPhone = deviceType == DeviceType.phone;
    return Padding(
      padding: EdgeInsets.only(top: isPhone ? 16.0 : 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'My portfolio',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: deviceType == DeviceType.desktop
                  ? 3
                  : deviceType == DeviceType.tablet
                      ? 2
                      : 1,
              children: widget.projects
                  .map(
                    (project) => _PortfolioContainer(
                      image: project.image,
                      title: project.title,
                      onTap: () => _showDataDialog(
                        project.image,
                        project.title,
                        project.role,
                        project.description,
                        project.link,
                      ),
                    ),
                  )
                  .toList()),
        ],
      ),
    );
  }

  _showDataDialog(String image, String title, String subtitle,
      String description, String? link) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          image: image,
          title: title,
          subtitle: subtitle,
          description: description,
          link: link,
        );
      },
    );
  }
}

class _PortfolioContainer extends StatefulWidget {
  const _PortfolioContainer({
    required this.image,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  State<_PortfolioContainer> createState() => _PortfolioContainerState();
}

class _PortfolioContainerState extends State<_PortfolioContainer> {
  bool _isArrowVisible = false;

  @override
  Widget build(BuildContext context) {
    final deviceType = context.read<DeviceInfo>().deviceType;
    final isDesktop = deviceType == DeviceType.desktop;
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
            Center(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isDesktop)
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
