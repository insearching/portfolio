import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/contact_form_event.dart';
import 'package:portfolio/main/bloc/portfolio_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_state.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/service_locator.dart';
import 'package:portfolio/main/ui/blog/blog_bloc.dart';
import 'package:portfolio/main/ui/blog/blog_event.dart';
import 'package:portfolio/main/ui/blog/blog_state.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/contact.dart';
import 'package:portfolio/main/ui/home.dart';
import 'package:portfolio/main/ui/keys.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_bloc.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_event.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_blog.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_features.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_portfolio.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_resume.dart';
import 'package:portfolio/utils/constants.dart';

class MobileContent extends StatefulWidget {
  const MobileContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  State<MobileContent> createState() => _MobileContentState();
}

class _MobileContentState extends State<MobileContent> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: Home(
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
              ),
              const HorizontalDivider(),
              BlocProvider(
                create: (context) =>
                    BlogBloc(blogRepository: locator<BlogRepository>())
                      ..add(
                        const GetPosts(),
                      ),
                child: BlocBuilder<BlogBloc, BlogState>(
                  builder: (context, state) {
                    return MobileBlogWidget(
                      key: keys[NavigationMenu.blog],
                      blogState: state,
                    );
                  },
                ),
              ),
              const HorizontalDivider(),
              BlocProvider(
                create: (context) => PersonalInfoBloc(
                    positionRepo: locator<PositionRepository>())
                  ..add(
                    const GetPositions(),
                  ),
                child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                  builder: (context, state) {
                    return MobileFeatures(
                      key: keys[NavigationMenu.features],
                      state: state,
                    );
                  },
                ),
              ),
              const HorizontalDivider(),
              BlocBuilder<PortfolioBloc, PortfolioState>(
                builder: (context, state) {
                  return MobilePortfolio(
                    key: keys[NavigationMenu.portfolio],
                    projects: state.projects,
                  );
                },
              ),
              const HorizontalDivider(),
              BlocBuilder<PortfolioBloc, PortfolioState>(
                builder: (context, state) {
                  return MobileResume(
                    key: keys[NavigationMenu.resume],
                    educations: state.education,
                    skills: state.skills,
                    tabs: state.resumeTabs,
                  );
                },
              ),
              const HorizontalDivider(),
              BlocBuilder<PortfolioBloc, PortfolioState>(
                builder: (context, state) {
                  return Contact(
                    key: keys[NavigationMenu.contact],
                    info: state.personalInfo ??
                        const PersonalInfo(
                          image: '',
                          title: '',
                          description: '',
                          email: '',
                          socials: [],
                        ),
                    onMessageSend: widget.onMessageSend,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
