import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/utils/theme.dart';

import 'main/ui/components/app_error_widget.dart';
import 'main/ui/main_page.dart';

const String userName = 'Serhii Hrabas';

void main() {
  if (kReleaseMode) ErrorWidget.builder = (_) => const AppErrorWidget();
  runApp(const PortfolioApplication());
}

class PortfolioApplication extends StatelessWidget {
  const PortfolioApplication({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: userName,
      theme: CustomTheme.mainTheme,
      home: MainPage(
        name: userName,
        onMessageSend: (text) {
          //todo add callback
        }
      ),
    );
  }
}
