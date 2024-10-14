import 'package:flutter/material.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/ui/components/custom_dialog.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({
    required this.projects,
    required this.isDesktop,
    required this.isTablet,
    super.key,
  });

  final List<Project> projects;
  final bool isDesktop;
  final bool isTablet;

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          const ContainerTitle(title: 'My portfolio', subtitle: 'Visit my portfolio and leave your feedback'),
          const SizedBox(height: 32.0),
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: widget.isDesktop ? 3 : widget.isTablet ? 2 : 1,
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
                  .toList()
              ),
        ],
      ),
    );
  }

  _showDataDialog(
      String image, String title, String subtitle, String description, String? link) {
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
            const SizedBox(height: 32.0),
            Center(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
