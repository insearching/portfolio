import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/circle_image.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/contact.dart';
import 'package:portfolio/main/ui/features.dart';
import 'package:portfolio/main/ui/home.dart';
import 'package:portfolio/main/ui/navigation_panel.dart';
import 'package:portfolio/main/ui/portfolio.dart';
import 'package:portfolio/main/ui/resume.dart';
import 'package:portfolio/main/ui/socials.dart';
import 'package:portfolio/utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<InputForm> onMessageSend;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final homeKey = GlobalKey();
  final featuresKey = GlobalKey();
  final portfolioKey = GlobalKey();
  final resumeKey = GlobalKey();
  final clientsKey = GlobalKey();
  final pricingKey = GlobalKey();
  final blogKey = GlobalKey();
  final contactKey = GlobalKey();

  final animationDuration = const Duration(milliseconds: 500);

  GlobalKey parsePosition(int position) {
    switch (position) {
      case 0:
        return homeKey;
      case 1:
        return featuresKey;
      case 2:
        return portfolioKey;
      case 3:
        return resumeKey;
      case 4:
        return clientsKey;
      case 5:
        return pricingKey;
      case 6:
        return blogKey;
      case 7:
        return contactKey;
      default:
        return homeKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController controller = ScrollController();

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
                      final context = parsePosition(position).currentContext;
                      if (context != null) {
                        Scrollable.ensureVisible(
                          context,
                          duration: animationDuration,
                        );
                      }
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Home(
                        key: homeKey,
                        name: widget.name,
                      ),
                      const HorizontalDivider(),
                      Features(
                        key: featuresKey,
                      ),
                      const HorizontalDivider(),
                      Portfolio(
                        key: portfolioKey,
                        projects: Repository.projects,
                      ),
                      const HorizontalDivider(),
                      Resume(
                        key: resumeKey,
                      ),
                      const HorizontalDivider(),
                      Contact(
                        key: contactKey,
                        info: Repository.info,
                        onMessageSend: widget.onMessageSend,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
