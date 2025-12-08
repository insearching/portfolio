import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';

/// Theme extension for ElevatedContainer styling
class ElevatedContainerTheme extends ThemeExtension<ElevatedContainerTheme> {
  final List<Color> gradientColorsNormal;
  final List<Color> gradientColorsElevated;
  final Alignment gradientBeginNormal;
  final Alignment gradientEndNormal;
  final Alignment gradientBeginElevated;
  final Alignment gradientEndElevated;
  final Color shadowColorLight;
  final Color shadowColorDark;
  final double borderRadius;
  final Duration animationDuration;

  const ElevatedContainerTheme({
    required this.gradientColorsNormal,
    required this.gradientColorsElevated,
    required this.gradientBeginNormal,
    required this.gradientEndNormal,
    required this.gradientBeginElevated,
    required this.gradientEndElevated,
    required this.shadowColorLight,
    required this.shadowColorDark,
    required this.borderRadius,
    required this.animationDuration,
  });

  /// Dark theme configuration
  static const ElevatedContainerTheme dark = ElevatedContainerTheme(
    gradientColorsNormal: [
      UIColors.backgroundColorDark,
      Color(0xFF1D1F22),
      Color(0xFF1D2021),
      Color(0xFF1D2020),
      UIColors.backgroundColorLight,
    ],
    gradientColorsElevated: [
      UIColors.backgroundColorDark,
      UIColors.backgroundColorDark,
      UIColors.backgroundColorDark,
      UIColors.backgroundColorDark,
      UIColors.backgroundColorLight,
    ],
    gradientBeginNormal: Alignment.topLeft,
    gradientEndNormal: Alignment.bottomRight,
    gradientBeginElevated: Alignment.bottomRight,
    gradientEndElevated: Alignment.topLeft,
    shadowColorLight: Color(0xFF313135),
    shadowColorDark: Color(0xDE161515),
    borderRadius: 5.0,
    animationDuration: Duration(milliseconds: 200),
  );

  /// Light theme configuration
  static const ElevatedContainerTheme light = ElevatedContainerTheme(
    gradientColorsNormal: [
      UIColors.lightBackgroundColorDark,
      Color(0xFFE2E0DD),
      Color(0xFFE2DFDE),
      Color(0xFFE2DFDF),
      UIColors.lightBackgroundColorLight,
    ],
    gradientColorsElevated: [
      UIColors.lightBackgroundColorDark,
      UIColors.lightBackgroundColorDark,
      UIColors.lightBackgroundColorDark,
      UIColors.lightBackgroundColorDark,
      UIColors.lightBackgroundColorLight,
    ],
    gradientBeginNormal: Alignment.topLeft,
    gradientEndNormal: Alignment.bottomRight,
    gradientBeginElevated: Alignment.bottomRight,
    gradientEndElevated: Alignment.topLeft,
    shadowColorLight: Color(0xFFCECACA),
    shadowColorDark: Color(0x21E9EAEA),
    borderRadius: 5.0,
    animationDuration: Duration(milliseconds: 200),
  );

  @override
  ThemeExtension<ElevatedContainerTheme> copyWith({
    List<Color>? gradientColorsNormal,
    List<Color>? gradientColorsElevated,
    Alignment? gradientBeginNormal,
    Alignment? gradientEndNormal,
    Alignment? gradientBeginElevated,
    Alignment? gradientEndElevated,
    Color? shadowColorLight,
    Color? shadowColorDark,
    double? borderRadius,
    Duration? animationDuration,
  }) {
    return ElevatedContainerTheme(
      gradientColorsNormal: gradientColorsNormal ?? this.gradientColorsNormal,
      gradientColorsElevated:
          gradientColorsElevated ?? this.gradientColorsElevated,
      gradientBeginNormal: gradientBeginNormal ?? this.gradientBeginNormal,
      gradientEndNormal: gradientEndNormal ?? this.gradientEndNormal,
      gradientBeginElevated:
          gradientBeginElevated ?? this.gradientBeginElevated,
      gradientEndElevated: gradientEndElevated ?? this.gradientEndElevated,
      shadowColorLight: shadowColorLight ?? this.shadowColorLight,
      shadowColorDark: shadowColorDark ?? this.shadowColorDark,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  @override
  ThemeExtension<ElevatedContainerTheme> lerp(
    covariant ThemeExtension<ElevatedContainerTheme>? other,
    double t,
  ) {
    if (other is! ElevatedContainerTheme) {
      return this;
    }

    return ElevatedContainerTheme(
      gradientColorsNormal: _lerpColorList(
        gradientColorsNormal,
        other.gradientColorsNormal,
        t,
      ),
      gradientColorsElevated: _lerpColorList(
        gradientColorsElevated,
        other.gradientColorsElevated,
        t,
      ),
      gradientBeginNormal:
          Alignment.lerp(gradientBeginNormal, other.gradientBeginNormal, t)!,
      gradientEndNormal:
          Alignment.lerp(gradientEndNormal, other.gradientEndNormal, t)!,
      gradientBeginElevated: Alignment.lerp(
          gradientBeginElevated, other.gradientBeginElevated, t)!,
      gradientEndElevated:
          Alignment.lerp(gradientEndElevated, other.gradientEndElevated, t)!,
      shadowColorLight:
          Color.lerp(shadowColorLight, other.shadowColorLight, t)!,
      shadowColorDark: Color.lerp(shadowColorDark, other.shadowColorDark, t)!,
      borderRadius: _lerpDouble(borderRadius, other.borderRadius, t),
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
    );
  }

  List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;

    return List.generate(
      a.length,
      (index) => Color.lerp(a[index], b[index], t)!,
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
