import 'package:flutter/material.dart';
import 'package:portfolio/main/components/custom_dialog.dart';
import 'package:portfolio/main/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

import 'data/project.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text('Visit my portfolio and leave your feedback'.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 32.0),
          Text(
            'My portfolio',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: widget.projects.map(
              (project) => _PortfolioContainer(
                image: project.image,
                title: project.title,
                onTap: () => _showDataAlert(
                  project.image,
                  project.title,
                  project.description
                ),
              ),
            ).toList()

            // Generate 100 widgets that display their index in the List.
            // children: [
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'Kontrolle app for SBB trains',
            //     onTap: () => _showDataAlert(
            //       'assets/img/sbb-app.jpg',
            //     ),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sumex.png',
            //     title: 'Sumex Insurance app',
            //     onTap: () => _showDataAlert('assets/img/sumex.png'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'Medically Home',
            //     onTap: () => _showDataAlert('assets/img/sbb-app.jpg'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'Cashplus. Banking App',
            //     onTap: () => _showDataAlert('assets/img/sbb-app.jpg'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sumex.png',
            //     title: 'Daimler app',
            //     onTap: () => _showDataAlert('assets/img/sumex.png'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'MiniMed medical app',
            //     onTap: () => _showDataAlert('assets/img/sbb-app.jpg'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'MiniMed medical app',
            //     onTap: () => _showDataAlert('assets/img/sbb-app.jpg'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'Mechanic Advisor',
            //     onTap: () => _showDataAlert('assets/img/sbb-app.jpg'),
            //   ),
            //   _PortfolioContainer(
            //     image: 'assets/img/sbb-app.jpg',
            //     title: 'Unlimited Biking',
            //     onTap: () => _showDataAlert('assets/img/sbb-app.jpg'),
            //   ),
            // ],
          ),
        ],
      ),
    );
  }

  _showDataAlert(String image, String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          image: image,
          title: title,
          text: description,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedContainer(
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
              Center(
                child: Image.asset(
                  widget.image,
                  height: 200,
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge,
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
      ),
    );
  }
}
