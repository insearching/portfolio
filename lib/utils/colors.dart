import 'package:flutter/material.dart';

class UIColors {
  // Common colors
  static const Color accent = Color.fromARGB(255, 249, 0, 77);
  static const Color red = Colors.red;
  static const Color goldTips = Color(0xFFE1B714);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Colors.black;
  static const Color fontBlack = Color(0xDE000000);
  static const Color logoBlue = Color(0xFF245f97);

  // Dark theme colors
  static const Color textFieldBackground = Colors.indigo;
  static const Color backgroundColor = Color(0xFF212428);
  static const Color backgroundColorDark = Color(0xFF1D2023);
  static const Color backgroundColorLight = Color(0xFF1F2328);
  static const Color hintColor = Colors.indigo;
  static const Color hoverColor = Color(0xFF9FA8DA);
  static const Color darkGrey = Color(0xFF383B41);
  static const Color lightGrey = Color(0xFFF5F6F7);
  static const Color lightShadow = Color.fromRGBO(0, 0, 0, 0.15);
  static const Color defaultTextColor = Color.fromARGB(255, 196, 207, 222);

  // Light theme colors (inverted from dark theme)
  static const Color lightBackgroundColor =
      Color(0xFFDEDBD7); // Inverted from #212428
  static const Color lightBackgroundColorDark =
      Color(0xFFE2DFDC); // Inverted from #1D2023
  static const Color lightBackgroundColorLight =
      Color(0xFFE0DCD7); // Inverted from #1F2328
  static const Color lightTextColor =
      Color(0xFF3C3021); // Inverted from #C4CFDE (darker for readability)
  static const Color lightTextColorSecondary =
      Color(0xFF0A0908); // Inverted from #F5F6F7
  static const Color lightHoverColor =
      Color(0xFF605723); // Inverted from #9FA8DA
  static const Color lightBorderColor =
      Color(0xFFC7C4BE); // Inverted from #383B41
  static const Color lightShadowColor =
      Color.fromRGBO(255, 255, 255, 0.15); // Inverted shadow
}
