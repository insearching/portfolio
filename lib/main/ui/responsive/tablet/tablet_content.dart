import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/contact_form_event.dart';
import 'package:portfolio/main/bloc/portfolio_bloc.dart';
import 'package:portfolio/main/bloc/portfolio_state.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/repository/blog_repository.dart';
import 'package:portfolio/main/data/repository/position_repository.dart';
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
import 'package:portfolio/main/ui/portfolio.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_blog.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_features.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_resume.dart';
import 'package:portfolio/utils/constants.dart';

class TabletContent extends StatefulWidget {
  const TabletContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  State<TabletContent> createState() => _TabletContentState();
}

class _TabletContentState extends State<TabletContent> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                BlocProvider(
                  create: (context) =>
                      BlogBloc(blogRepository: locator<BlogRepository>())
                        ..add(
                          GetPosts(),
                        ),
                  child: BlocBuilder<BlogBloc, BlogState>(
                    builder: (context, state) {
                      return TabletBlogWidget(
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
                      GetPositions(),
                    ),
                  child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                    builder: (context, state) {
                      return TabletFeatures(
                        key: keys[NavigationMenu.features],
                        state: state,
                      );
                    },
                  ),
                ),
                const HorizontalDivider(),
                BlocBuilder<PortfolioBloc, PortfolioState>(
                  builder: (context, state) {
                    return Portfolio(
                      key: keys[NavigationMenu.portfolio],
                      projects: state.projects,
                    );
                  },
                ),
                const HorizontalDivider(),
                BlocBuilder<PortfolioBloc, PortfolioState>(
                  builder: (context, state) {
                    return TabletResume(
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
      ),
    );
  }
}
