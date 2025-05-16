import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_scaffold.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_scaffold.dart';
import 'package:portfolio/main/ui/responsive/responsive_layout.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_scaffold.dart';

const String userName = 'Serhii Hrabas';

class MainPageModule extends StatefulWidget {
  const MainPageModule({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageModuleState createState() => _MainPageModuleState();
}

class _MainPageModuleState extends State<MainPageModule> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MobileScaffold(
        name: userName,
        onMessageSend: (form) {},
      ),
      tabletScaffold: TabletScaffold(
        name: userName,
        onMessageSend: (form) {},
      ),
      desktopScaffold: DesktopScaffold(
        name: userName,
        onMessageSend: (form) {},
      ),
    );
  }
}
