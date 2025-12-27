import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/main/ui/contact/contact_form_event.dart';
import 'package:portfolio/main/ui/content.dart';
import 'package:portfolio/main/ui/menu/drawing_menu.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({
    required this.name,
    required this.onMessageSend,
    super.key,
  });

  final String name;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          if (kDebugMode && kIsWeb) {
            context.go('/admin');
          }
        },
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              const DrawingMenu(),
              VerticalDivider(
                width: 1.0,
                color: Theme.of(context).dividerColor,
              ),
              Content(
                name: name,
                onMessageSend: onMessageSend,
              )
            ],
          ),
        ),
      ),
    );
  }
}
