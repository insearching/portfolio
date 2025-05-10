import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/left_panel.dart';
import 'package:portfolio/main/ui/main_bloc.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_content.dart';
import 'package:portfolio/utils/colors.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({
    required this.name,
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final String name;
  final ValueChanged<SubmitFormEvent> onMessageSend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: UIColors.backgroundColor,
        child: Row(
          children: [
            const LeftPanel(),
            const VerticalDivider(width: 1.0, color: UIColors.black),
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
