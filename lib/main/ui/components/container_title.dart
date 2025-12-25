import 'package:flutter/material.dart';

class ContainerTitle extends StatelessWidget {
  const ContainerTitle(
      {required this.title, required this.subtitle, super.key});

  final String title;

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(subtitle.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 32.0),
        Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }
}
