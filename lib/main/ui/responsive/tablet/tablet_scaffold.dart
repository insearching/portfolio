import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/contact/contact_form_event.dart';
import 'package:portfolio/main/ui/content.dart';
import 'package:portfolio/main/ui/menu/drawing_menu.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({
    super.key,
    required this.name,
    required this.onMessageSend,
  });

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    var isDrawerOpen = false;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 25,
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Content(
            name: widget.name,
            onMessageSend: widget.onMessageSend,
          ),
        ),
      ),
      drawer: Drawer(
        width: 250.0,
        child: DrawingMenu(
          onMenuItemSelected: () {
            Navigator.of(context).pop();
            setState(() {
              isDrawerOpen = false;
            });
          },
        ),
      ),
    );
  }
}
