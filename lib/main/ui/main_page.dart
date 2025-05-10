import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/data/device_info.dart';
import 'package:portfolio/main/data/device_type.dart';
import 'package:portfolio/main/ui/left_panel.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/main_content.dart';
import 'package:portfolio/utils/colors.dart';

const animationDuration = Duration(milliseconds: 500);

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
        body: isDesktop
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
        drawer: const Drawer(
          backgroundColor: UIColors.backgroundColor,
          child: LeftPanel(),
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
        const LeftPanel(),
        const VerticalDivider(width: 1.0, color: UIColors.black),
        MainContent(
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
    return MainContent(
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
    return MainContent(
      name: widget.name,
      onMessageSend: widget.onMessageSend,
    );
  }
}
