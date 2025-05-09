import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/uifonts.dart';

class CustomTheme {
  static ThemeData desktopTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.indigo.shade900,

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and etc.
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: UIColors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightGrey,
      ),
      displaySmall: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: UIColors.defaultTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      titleMedium: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        color: UIColors.defaultTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      bodyLarge: TextStyle(
        fontSize: 24.0,
        color: UIColors.defaultTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: UIColors.defaultTextColor,
      ),
      labelLarge: TextStyle(
        color: UIColors.accent,
        fontFamily: UIFonts.hkMontserrat,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    ),
  );

  static ThemeData phoneTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.indigo.shade900,

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and etc.
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: UIColors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightGrey,
      ),
      displaySmall: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: UIColors.defaultTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      titleMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: UIColors.defaultTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.0,
        color: UIColors.defaultTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: UIColors.defaultTextColor,
      ),
      labelLarge: TextStyle(
        color: UIColors.accent,
        fontFamily: UIFonts.hkMontserrat,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
  );
}
