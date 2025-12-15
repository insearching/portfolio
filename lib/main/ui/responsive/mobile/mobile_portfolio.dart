import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/ui/components/custom_dialog.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_container.dart';

class MobilePortfolio extends StatelessWidget {
  const MobilePortfolio({
    required this.projects,
    super.key,
  });

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'My portfolio',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          IntrinsicHeight(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: projects
                    .map(
                      (project) => IntrinsicHeight(
                        child: PortfolioContainer(
                          image: project.image,
                          title: project.title,
                          onTap: () => _showDataDialog(
                            context,
                            project.image,
                            project.title,
                            project.role,
                            project.description,
                            project.link,
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
        ],
      ),
    );
  }

  _showDataDialog(
    BuildContext context,
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
