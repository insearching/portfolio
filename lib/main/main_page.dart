import 'package:flutter/material.dart';
import 'package:portfolio/main/components/horizontal_divider.dart';
import 'package:portfolio/main/features.dart';
import 'package:portfolio/main/home.dart';
import 'package:portfolio/main/navigation_panel.dart';
import 'package:portfolio/utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({required this.name, Key? key}) : super(key: key);

  final String name;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController _controller = new ScrollController();

    void _goToElement(int index) {
      _controller.animateTo(
          (100.0 * index), // 100 is the height of container and index of 6th element is 5
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          color: UIColors.backgroundColor,
          child: Row(
            children: [
              const NavigationPanel(),
              const VerticalDivider(width: 1.0, color: UIColors.black),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Home(name),
                      Padding(
                        padding: EdgeInsets.only(left: 48.0, right: 48.0),
                        child: HorizontalDivider(),
                      ),
                      Features(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
