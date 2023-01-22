import 'package:flutter/material.dart';
import 'package:portfolio/main/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class Features extends StatelessWidget {
  const Features({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text('Features'.toUpperCase(), style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 32.0),
          Text(
            'What I Do',
            style: Theme.of(context).textTheme.headline3,
          ),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(
                  child: FeatureContainer(
                    imageAsset: 'assets/img/home.png',
                    title: 'Title',
                    subtitle: 'Subtitle',
                  ),
                ),
                SizedBox(width: 24.0),
                Expanded(
                  child: FeatureContainer(
                    imageAsset: 'assets/img/home.png',
                    title: 'Title',
                    subtitle: 'Subtitle',
                  ),
                ),
                SizedBox(width: 24.0),
                Expanded(
                  child: FeatureContainer(
                    imageAsset: 'assets/img/home.png',
                    title: 'Title',
                    subtitle: 'Subtitle',
                  ),
                ),
                SizedBox(width: 24.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureContainer extends StatefulWidget {
  const FeatureContainer({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  final String imageAsset;
  final String title;
  final String subtitle;

  @override
  State<FeatureContainer> createState() => _FeatureContainerState();
}

class _FeatureContainerState extends State<FeatureContainer> {
  bool _isArrowVisible = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      onElevatedChanged: (value) {
        setState(() {
          _isArrowVisible = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/img/home.png',
              color: UIColors.accent,
              width: 50.0,
              height: 50.0,
            ),
            const SizedBox(height: 32.0),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 24.0),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Opacity(
              opacity: _isArrowVisible ? 1.0 : 0.0,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 24.0),
                  Icon(
                    Icons.arrow_forward,
                    size: 40.0,
                    color: UIColors.accent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
