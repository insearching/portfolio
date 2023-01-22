import 'package:flutter/material.dart';
import 'package:portfolio/main/main_page.dart';
import 'package:portfolio/utils/theme.dart';

const final NAME = 'Serhii Hrabas'

void main() {
  runApp(const PortfolioApplication());
}

class PortfolioApplication extends StatelessWidget {
  const PortfolioApplication({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: NAME,
      theme: CustomTheme.mainTheme,
      home: const MainPage(NAME),
    );
  }
}
