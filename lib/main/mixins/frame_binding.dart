import 'package:flutter/material.dart';

mixin FrameBinding<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    runAfterLayout(() => didRenderFrame(context));
  }

  void didRenderFrame(BuildContext context) {}

  void runAfterLayout(VoidCallback callback) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => callback());
}
