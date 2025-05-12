import 'package:flutter/material.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/features.dart';
import 'package:portfolio/main/ui/home.dart';
import 'package:portfolio/main/ui/keys.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/main_page.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_contact.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_portfolio.dart';
import 'package:portfolio/main/ui/resume.dart';
import 'package:portfolio/utils/colors.dart';

class DesktopContent extends StatefulWidget {
  const DesktopContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<DesktopContent> createState() => _DesktopContentState();
}

class _DesktopContentState extends State<DesktopContent> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Expanded(
      child: Container(
        color: UIColors.backgroundColor,
        child: SingleChildScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Home(
                  key: keys[NavigationMenu.home],
                  name: widget.name,
                  onContactClicked: () {
                    final context =
                        keys[NavigationMenu.contact]?.currentContext;
                    if (context != null) {
                      Scrollable.ensureVisible(
                        context,
                        duration: animationDuration,
                      );
                    }
                  },
                ),
                const HorizontalDivider(),
                Features(
                  key: keys[NavigationMenu.features],
                  responsibilities: Repository.responsibilities,
                ),
                const HorizontalDivider(),
                DesktopPortfolio(
                  key: keys[NavigationMenu.portfolio],
                  projects: Repository.projects,
                ),
                const HorizontalDivider(),
                Resume(
                    key: keys[NavigationMenu.resume],
                    educations: Repository.educationInfo,
                    skills: Repository.skills,
                    posts: Repository.posts),
                const HorizontalDivider(),
                DesktopContact(
                    key: keys[NavigationMenu.contact],
                    info: Repository.info,
                    onMessageSend: widget.onMessageSend),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
