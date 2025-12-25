import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/contact/contact_form_event.dart';
import 'package:portfolio/main/ui/menu/drawing_menu.dart';

import 'mobile_content.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({
    required this.name,
    required this.onMessageSend,
    super.key,
  });

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
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
        child: MobileContent(
          name: widget.name,
          onMessageSend: widget.onMessageSend,
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
