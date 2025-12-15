import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/contact/contact_form_event.dart';
import 'package:portfolio/main/ui/menu/drawing_menu.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_content.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            const DrawingMenu(),
            VerticalDivider(
              width: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            DesktopContent(
              name: name,
              onMessageSend: onMessageSend,
            )
          ],
        ),
      ),
    );
  }
}
