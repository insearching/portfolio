import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/left_panel.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/utils/colors.dart';

import 'mobile_content.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    var isDrawerOpen = false;
    return Scaffold(
      appBar: AppBar(
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
                setState(() {
                  isDrawerOpen = !isDrawerOpen;
                });
                if (isDrawerOpen) {
                  Scaffold.of(context).openDrawer();
                } else {
                  Scaffold.of(context).closeDrawer();
                }
              },
            );
          },
        ),
      ),
      body: MobileContent(
        name: widget.name,
        onMessageSend: widget.onMessageSend,
      ),
      drawer: const Drawer(
        backgroundColor: UIColors.backgroundColor,
        width: 250.0,
        child: LeftPanel(),
      ),
    );
  }
}
