import 'package:flutter/material.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/ui/components/custom_dialog.dart';
import 'package:portfolio/main/ui/portfolio_container.dart';

class DesktopPortfolio extends StatefulWidget {
  const DesktopPortfolio({
    required this.projects,
    super.key,
  });

  final List<Project> projects;

  @override
  State<DesktopPortfolio> createState() => _DesktopPortfolioState();
}

class _DesktopPortfolioState extends State<DesktopPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'My portfolio',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: widget.projects
                .map(
                  (project) => PortfolioContainer(
                    image: project.image,
                    title: project.title,
                    showArrow: true,
                    onTap: () => _showDataDialog(
                      project.image,
                      project.title,
                      project.role,
                      project.description,
                      project.link,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  _showDataDialog(
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
