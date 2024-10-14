import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/utils/colors.dart';

class Feature {}

class Features extends StatefulWidget {
  const Features({
    required this.isDesktop,
    required this.isTablet,
    Key? key,
  }) : super(key: key);

  final bool isDesktop;
  final bool isTablet;

  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          const ContainerTitle(title: 'What I Do', subtitle: 'Features'),
          const SizedBox(height: 24.0),
          widget.isDesktop || widget.isTablet
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _FeatureContainer(
                          icon: 'assets/img/android.png',
                          title: 'Android development',
                          body:
                              'As a Senior Android Developer with 10 years of experience, '
                              'I have had the opportunity to work across a variety of industries, '
                              'including banking, retail, automotive, and medical. '
                              'My technical expertise is complemented by strong soft '
                              'skills and excellent communication, allowing me to '
                              'effectively collaborate with teams and engage with '
                              'stakeholders to ensure that project goals are met.',
                          isPhone: false,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.0),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _FeatureContainer(
                          icon: 'assets/img/flutter.png',
                          title: 'Flutter development',
                          body:
                              'With 10 years of experience in mobile development, I specialize as '
                              'a Senior Flutter Developer, working across diverse industries '
                              'including banking, retail, automotive, and medical. '
                              'My proficiency in developing cross-platform applications using '
                              'Flutter is paired with strong interpersonal skills and effective '
                              'communication, ensuring seamless collaboration with teams and '
                              'stakeholders to deliver robust and scalable solutions.',
                          isPhone: false,
                        ),
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FeatureContainer(
                      icon: 'assets/img/android.png',
                      title: 'Android development',
                      body:
                          'As a Senior Android Developer with 10 years of experience, I have had '
                          'the opportunity to work across a variety of industries, including '
                          'banking, retail, automotive, and medical. My technical expertise is '
                          'complemented by strong soft skills and excellent communication, '
                          'allowing me to effectively collaborate with teams and engage with '
                          'stakeholders to ensure that project goals are met.',
                      isPhone: true,
                    ),
                    SizedBox(height: 24.0),
                    _FeatureContainer(
                      icon: 'assets/img/flutter.png',
                      title: 'Flutter development',
                      body: 'With 10 years of experience in mobile development, '
                          'I specialize as a Senior Flutter Developer, working across '
                          'diverse industries including banking, retail, automotive, '
                          'and medical. My proficiency in developing cross-platform '
                          'applications using Flutter is paired with strong interpersonal'
                          ' skills and effective communication, ensuring seamless '
                          'collaboration with teams and stakeholders to deliver '
                          'robust and scalable solutions.',
                      isPhone: true,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

class _FeatureContainer extends StatefulWidget {
  const _FeatureContainer({
    required this.icon,
    required this.title,
    required this.body,
    required this.isPhone,
    Key? key,
  }) : super(key: key);

  final String icon;
  final String title;
  final String body;
  final bool isPhone;

  @override
  State<_FeatureContainer> createState() => _FeatureContainerState();
}

class _FeatureContainerState extends State<_FeatureContainer> {
  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.icon,
              color: UIColors.accent,
              width: 50.0,
              height: 50.0,
            ),
            const SizedBox(height: 32.0),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24.0),
            _FeatureBody(
              body: widget.body,
              isScrollable: !widget.isPhone,
            )
          ],
        ),
      ),
    );
  }
}

class _FeatureBody extends StatefulWidget {
  const _FeatureBody({
    required this.body,
    required this.isScrollable,
    Key? key,
  }) : super(key: key);

  final String body;
  final bool isScrollable;

  @override
  State<_FeatureBody> createState() => _FeatureBodyState();
}

class _FeatureBodyState extends State<_FeatureBody> {
  @override
  Widget build(BuildContext context) {
    return widget.isScrollable
        ? Flexible(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Text(
                widget.body,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        : Text(
            widget.body,
            style: Theme.of(context).textTheme.bodyMedium,
          );
  }
}
