import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/ui/components/custom_dialog.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_container.dart';
import 'package:provider/provider.dart';

import '../../domain/model/device_type.dart';

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
    return Padding(
      padding:
          EdgeInsets.only(top: deviceType.isPhone ? 16.0 : 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'My portfolio',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: deviceType.isDesktop
                  ? 3
                  : deviceType.isTablet
                      ? 2
                      : 1,
              children: widget.projects
                  .map(
                    (project) => PortfolioContainer(
                      image: project.image,
                      title: project.title,
                      showArrow: deviceType.isDesktop,
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

  void _showDataDialog(
    String image,
    String title,
    String subtitle,
    String description,
    String? link,
  ) {
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
