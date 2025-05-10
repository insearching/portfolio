import 'package:flutter/material.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/contact.dart';
import 'package:portfolio/main/ui/keys.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/main_page.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_features.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_home.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_portfoilio.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_resume.dart';
import 'package:portfolio/utils/colors.dart';

class MobileContent extends StatefulWidget {
  const MobileContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<MobileContent> createState() => _MobileContentState();
}

class _MobileContentState extends State<MobileContent> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Container(
      color: UIColors.backgroundColor,
      child: SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MobileHome(
                key: keys[NavigationMenu.home],
                name: widget.name,
                onContactClicked: () {
                  final context = keys[NavigationMenu.contact]?.currentContext;
                  if (context != null) {
                    Scrollable.ensureVisible(
                      context,
                      duration: animationDuration,
                    );
                  }
                },
              ),
              const HorizontalDivider(),
              MobileFeatures(
                key: keys[NavigationMenu.features],
                responsibilities: Repository.responsibilities,
              ),
              const HorizontalDivider(),
              MobilePortfolio(
                key: keys[NavigationMenu.portfolio],
                projects: Repository.projects,
              ),
              const HorizontalDivider(),
              MobileResume(
                key: keys[NavigationMenu.resume],
                educations: Repository.educationInfo,
                skills: Repository.skills,
                posts: Repository.posts,
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
    );
  }
}
