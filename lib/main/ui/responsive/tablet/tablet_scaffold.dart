import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/left_panel.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_content.dart';
import 'package:portfolio/utils/colors.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({
    Key? key,
    required this.name,
    required this.onMessageSend,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
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
      body: Container(
        color: UIColors.backgroundColor,
        child: TabletContent(
          name: widget.name,
          onMessageSend: widget.onMessageSend,
        ),
      ),
      drawer: const Drawer(
        backgroundColor: UIColors.backgroundColor,
        width: 250.0,
        child: LeftPanel(),
      ),
    );
  }
}
