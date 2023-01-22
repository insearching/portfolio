import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/uifonts.dart';

class CustomTheme {
  static ThemeData mainTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.indigo.shade900,

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and etc.
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: UIColors.white,
      ),
      headline2: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightGrey,
      ),
      headline3: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: UIColors.defaultTextColor,
      ),
      headline4: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      subtitle1: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        color: UIColors.defaultTextColor,
      ),
      subtitle2: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      bodyText1: TextStyle(
        fontSize: 24.0,
        color: UIColors.defaultTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyText2: TextStyle(
        fontSize: 16.0,
        color: UIColors.defaultTextColor,
      ),
      button: TextStyle(
        color: UIColors.accent,
        fontFamily: UIFonts.hkMontserrat,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    ),
  );
}
