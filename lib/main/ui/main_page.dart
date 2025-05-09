import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/data/device_info.dart';
import 'package:portfolio/main/data/device_type.dart';
import 'package:portfolio/main/data/navigation_menu.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/contact.dart';
import 'package:portfolio/main/ui/features.dart';
import 'package:portfolio/main/ui/home.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/navigation_panel.dart';
import 'package:portfolio/main/ui/portfolio.dart';
import 'package:portfolio/main/ui/resume.dart';
import 'package:portfolio/main/ui/socials.dart';
import 'package:portfolio/utils/colors.dart';

const animationDuration = Duration(milliseconds: 500);

final keys = {
  NavigationMenu.home: GlobalKey(),
  NavigationMenu.features: GlobalKey(),
  NavigationMenu.portfolio: GlobalKey(),
  NavigationMenu.resume: GlobalKey(),
  NavigationMenu.contact: GlobalKey()
};

class MainPage extends StatefulWidget {
  const MainPage({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final deviceType = context.read<DeviceInfo>().deviceType;
    final isDesktop = deviceType == DeviceType.desktop;
    final isTablet = deviceType == DeviceType.tablet;
    return BlocProvider(
      create: (BuildContext context) => MainBloc(),
      child: Scaffold(
        appBar: isDesktop
            ? null
            : AppBar(
                backgroundColor: UIColors.backgroundColor,
                leading: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 25,
                        color: UIColors.lightGrey,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
              ),
        body: Container(
          // height: size.height,
          // width: size.width,
          color: UIColors.backgroundColor,
          child: isDesktop
              ? _LargeScreenContent(
                  name: widget.name, onMessageSend: widget.onMessageSend)
              : isTablet
                  ? _MediumScreenContent(
                      name: widget.name,
                      onMessageSend: widget.onMessageSend,
                    )
                  : _SmallScreenContent(
                      name: widget.name,
                      onMessageSend: widget.onMessageSend,
                    ),
        ),
        drawer: const Drawer(
          backgroundColor: UIColors.backgroundColor,
          child: _LeftPanel(),
        ),
      ),
    );
  }
}

class _LargeScreenContent extends StatefulWidget {
  const _LargeScreenContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<_LargeScreenContent> createState() => _LargeScreenContentState();
}

class _LargeScreenContentState extends State<_LargeScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LeftPanel(),
        const VerticalDivider(width: 1.0, color: UIColors.black),
        _MainContent(
          name: widget.name,
          onMessageSend: widget.onMessageSend,
        )
      ],
    );
  }
}

class _MediumScreenContent extends StatefulWidget {
  const _MediumScreenContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<_MediumScreenContent> createState() => _MediumScreenContentState();
}

class _MediumScreenContentState extends State<_MediumScreenContent> {
  @override
  Widget build(BuildContext context) {
    return _MainContent(
      name: widget.name,
      onMessageSend: widget.onMessageSend,
    );
  }
}

class _SmallScreenContent extends StatefulWidget {
  const _SmallScreenContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<_SmallScreenContent> createState() => _SmallScreenContentState();
}

class _SmallScreenContentState extends State<_SmallScreenContent> {
  @override
  Widget build(BuildContext context) {
    return _MainContent(
      name: widget.name,
      onMessageSend: widget.onMessageSend,
    );
  }
}

class _LeftPanel extends StatefulWidget {
  const _LeftPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<_LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<_LeftPanel> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavigationPanel(
            onMenuItemSelected: (position) {
              final tagKey = NavigationMenu.keyByPosition(position);
              if (tagKey == null) return;
              final context = keys[tagKey]?.currentContext;
              if (context == null) return;
              Scrollable.ensureVisible(
                context,
                duration: animationDuration,
              );
            },
          ),
          const HorizontalDivider(),
          Socials(
              socials: Repository.info.socials
          ),
        ],
      ),
    );
  }
}

class _MainContent extends StatefulWidget {
  const _MainContent({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Expanded(
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
              Features(
                key: keys[NavigationMenu.features],
                responsibilities: Repository.responsibilities
              ),
              const HorizontalDivider(),
              Portfolio(
                key: keys[NavigationMenu.portfolio],
                projects: Repository.projects
              ),
              const HorizontalDivider(),
              Resume(
                key: keys[NavigationMenu.resume],
                educations: Repository.educationInfo,
                skills: Repository.skills,
                posts: Repository.posts
              ),
              const HorizontalDivider(),
              Contact(
                key: keys[NavigationMenu.contact],
                info: Repository.info,
                onMessageSend: widget.onMessageSend
              ),
            ],
          ),
        ),
      ),
    );
  }
}
