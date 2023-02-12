import 'package:flutter/material.dart';
import 'package:portfolio/main/components/circle_image.dart';
import 'package:portfolio/main/components/horizontal_divider.dart';
import 'package:portfolio/main/data/project.dart';
import 'package:portfolio/main/features.dart';
import 'package:portfolio/main/home.dart';
import 'package:portfolio/main/navigation_panel.dart';
import 'package:portfolio/main/portfolio.dart';
import 'package:portfolio/main/socials.dart';
import 'package:portfolio/utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({required this.name, Key? key}) : super(key: key);

  final String name;

  final List<Project> projects = const [
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Kontrolle app for SBB trains',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sumex.png',
      title: 'Sumex Insurance app',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Medically Home',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Cashplus. Banking App',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sumex.png',
      title: 'Daimler app',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'MiniMed medical app',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'MiniMed medical app',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Mechanic Advisor',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
    Project(
      image: 'assets/img/sbb-app.jpg',
      title: 'Unlimited Biking',
      role: 'Senior Android developer',
      description: 'Senior Android developer',
      link: '',
    ),
  ];

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController controller = ScrollController();

    void scrollToElement(int index) {
      double factor = 0.0;
      switch (index) {
        case 1:
          factor = 500;
          break;
        case 2:
          factor = 550;
          break;
        case 3:
          factor = 1200;
          break;
        case 4:
          factor = 1500;
          break;
      }
      controller.animateTo((factor * index),
          // 100 is the height of container and index of 6th element is 5
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut);
    }

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: UIColors.backgroundColor,
        child: Row(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                        color: UIColors.darkGrey, shape: BoxShape.circle),
                    child: const CircleImage(
                      imageAsset: 'assets/img/avatar.jpg',
                      radius: 70,
                    ),
                  ),
                  NavigationPanel(
                    onMenuItemSelected: (position) {
                      scrollToElement(position);
                    },
                  ),
                  const HorizontalDivider(),
                  const Socials(),
                ],
              ),
            ),
            const VerticalDivider(width: 1.0, color: UIColors.black),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Home(name: widget.name),
                    const HorizontalDivider(),
                    const Features(),
                    const HorizontalDivider(),
                    Portfolio(projects: widget.projects),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
