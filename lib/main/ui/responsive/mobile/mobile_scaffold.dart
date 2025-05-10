import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/left_panel.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_content.dart';
import 'package:portfolio/utils/colors.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key, required this.name}) : super(key: key);

  final String name;

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
      body: Container(
        color: UIColors.backgroundColor,
        child: MobileContent(
          name: widget.name,
          onMessageSend: (text) => {},
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
