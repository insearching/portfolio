import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/di/service_locator.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/ui/blog/blog_bloc.dart';
import 'package:portfolio/main/ui/blog/blog_event.dart';
import 'package:portfolio/main/ui/blog/blog_state.dart';
import 'package:portfolio/main/ui/blog/blog_widget.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/ui/contact/contact.dart';
import 'package:portfolio/main/ui/contact/contact_form_event.dart';
import 'package:portfolio/main/ui/features/features_widget.dart';
import 'package:portfolio/main/ui/home.dart';
import 'package:portfolio/main/ui/menu/keys.dart';
import 'package:portfolio/main/ui/menu/navigation_menu.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_bloc.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_event.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';
import 'package:portfolio/main/ui/portfolio/portfolio.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_bloc.dart';
import 'package:portfolio/main/ui/portfolio/portfolio_state.dart';
import 'package:portfolio/main/ui/resume/resume_widget.dart';
import 'package:portfolio/utils/constants.dart';

class Content extends StatefulWidget {
  const Content({
    required this.name,
    required this.onMessageSend,
    super.key,
  });

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final deviceType = context.read<DeviceInfo>().deviceType;

    final content = Container(
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
                padding: EdgeInsets.only(
                  top: deviceType.isDesktop ? 64.0 : 16.0,
                  bottom: deviceType.isDesktop ? 64.0 : 32.0,
                ),
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
                create: (context) => BlogBloc(
                    blogRepository: locator<BlogRepository>(),
                    logger: locator<AppLogger>())
                  ..add(
                    const GetPosts(),
                  ),
                child: BlocBuilder<BlogBloc, BlogState>(
                  builder: (context, state) {
                    return BlogWidget(
                      key: keys[NavigationMenu.blog],
                      blogState: state,
                    );
                  },
                ),
              ),
              const HorizontalDivider(),
              BlocProvider(
                create: (context) => PersonalInfoBloc(
                  positionRepo: locator<PositionRepository>(),
                  logger: locator<AppLogger>(),
                )..add(
                    const GetPositions(),
                  ),
                child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                  builder: (context, state) {
                    return FeaturesWidget(
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
                  return ResumeWidget(
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
                  if (state.status.isError) {
                    return Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Text(
                        state.errorMessage ?? 'Failed to load personal info',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.redAccent),
                      ),
                    );
                  }

                  if (state.personalInfo == null) {
                    // Show loading indicator while personal info is loading
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(64.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Contact(
                    key: keys[NavigationMenu.contact],
                    info: state.personalInfo!,
                    onMessageSend: widget.onMessageSend,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    // Desktop needs Expanded wrapper
    return deviceType.isDesktop ? Expanded(child: content) : content;
  }
}
