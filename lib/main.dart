import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/main/ui/responsive/desktop/desktop_scaffold.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_scaffold.dart';
import 'package:portfolio/main/ui/responsive/responsive_layout.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_scaffold.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/theme.dart';
import 'package:provider/provider.dart';

import 'main/data/device_info.dart';
import 'main/data/device_type.dart';
import 'main/ui/components/app_error_widget.dart';

const String userName = 'Serhii Hrabas';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: UIColors.backgroundColor, // Set your desired color
      statusBarIconBrightness: Brightness.light, // For white icons
    ),
  );
  ErrorWidget.builder = (_) => const AppErrorWidget();
  runApp(const RootProvider());
}

DeviceType _getDeviceType(BuildContext context) {
  final size = MediaQuery.of(context).size;
  if (size.width > 1000) return DeviceType.desktop;
  if (size.width > 600) return DeviceType.tablet;
  return DeviceType.phone;
}

class RootProvider extends StatelessWidget {
  const RootProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(context);

        final isSmallDevice = deviceType == DeviceType.phone;
        final theme =
            isSmallDevice ? CustomTheme.phoneTheme : CustomTheme.desktopTheme;

        return Provider<DeviceInfo>(
          create: (_) => DeviceInfo(deviceType),
          child: PortfolioApplication(
            theme: theme,
          ),
        );
      },
    );
  }
}

class PortfolioApplication extends StatelessWidget {
  const PortfolioApplication({
    required this.theme,
    Key? key,
  }) : super(key: key);

  final ThemeData theme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: userName,
      theme: theme,
      home: ResponsiveLayout(
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
      ),
    );
  }
}
