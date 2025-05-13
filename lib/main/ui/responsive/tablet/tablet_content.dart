import 'package:flutter/material.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/contact.dart';
import 'package:portfolio/main/ui/home.dart';
import 'package:portfolio/main/ui/keys.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/portfolio.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_features.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_resume.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/constants.dart';

class TabletContent extends StatefulWidget {
  const TabletContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<TabletContent> createState() => _TabletContentState();
}

class _TabletContentState extends State<TabletContent> {
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
                TabletFeatures(
                  key: keys[NavigationMenu.features],
                  responsibilities: Repository.responsibilities,
                ),
                const HorizontalDivider(),
                Portfolio(
                  key: keys[NavigationMenu.portfolio],
                  projects: Repository.projects,
                ),
                const HorizontalDivider(),
                TabletResume(
                  key: keys[NavigationMenu.resume],
                  educations: Repository.educationInfo,
                  skills: Repository.skills,
                  posts: Repository.posts,
                  tabs: Repository.tabs,
                ),
                const HorizontalDivider(),
                Contact(
                  key: keys[NavigationMenu.contact],
                  info: Repository.info,
                  onMessageSend: widget.onMessageSend,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
