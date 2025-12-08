import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/elevated_container_theme.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/uifonts.dart';

class PortfolioTheme {
  // Dark themes
  static ThemeData desktopDarkTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.indigo.shade900,
    scaffoldBackgroundColor: UIColors.backgroundColor,
    dividerColor: UIColors.black,
    shadowColor: UIColors.black,

    // Color scheme for consistent theming
    colorScheme: const ColorScheme.dark(
      primary: Colors.indigo,
      surface: UIColors.backgroundColor,
      onSurface: UIColors.lightGrey,
      surfaceContainerHighest: UIColors.darkGrey,
      onSurfaceVariant: UIColors.lightGrey,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: UIColors.backgroundColor,
      iconTheme: IconThemeData(color: UIColors.lightGrey),
    ),

    // Drawer theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: UIColors.backgroundColor,
    ),

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Custom theme extensions
    extensions: const <ThemeExtension<dynamic>>[
      ElevatedContainerTheme.dark,
    ],

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

  static ThemeData phoneDarkTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.indigo.shade900,
    scaffoldBackgroundColor: UIColors.backgroundColor,
    dividerColor: UIColors.black,
    shadowColor: UIColors.black,

    // Color scheme for consistent theming
    colorScheme: const ColorScheme.dark(
      primary: Colors.indigo,
      surface: UIColors.backgroundColor,
      onSurface: UIColors.lightGrey,
      surfaceContainerHighest: UIColors.darkGrey,
      onSurfaceVariant: UIColors.lightGrey,
    ),

    // AppBar theme
    appBarTheme: const AppBarThemeData(
      backgroundColor: UIColors.backgroundColor,
      iconTheme: IconThemeData(color: UIColors.lightGrey),
    ),

    // Drawer theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: UIColors.backgroundColor,
    ),

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Custom theme extensions
    extensions: const <ThemeExtension<dynamic>>[
      ElevatedContainerTheme.dark,
    ],

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

  // Light themes
  static ThemeData desktopLightTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.indigo.shade900,
    scaffoldBackgroundColor: UIColors.lightBackgroundColor,
    dividerColor: UIColors.lightBorderColor,
    shadowColor: UIColors.white,

    // Color scheme for consistent theming
    colorScheme: const ColorScheme.light(
      primary: Colors.indigo,
      surface: UIColors.lightBackgroundColor,
      onSurface: UIColors.lightTextColor,
      surfaceContainerHighest: UIColors.lightBorderColor,
      onSurfaceVariant: UIColors.lightTextColorSecondary,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: UIColors.lightBackgroundColor,
      iconTheme: IconThemeData(color: UIColors.lightTextColor),
    ),

    // Drawer theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: UIColors.lightBackgroundColor,
    ),

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Custom theme extensions
    extensions: const <ThemeExtension<dynamic>>[
      ElevatedContainerTheme.light,
    ],

    // Default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and etc.
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: UIColors.black, // Inverted from white
      ),
      displayMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightTextColorSecondary,
      ),
      displaySmall: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: UIColors.lightTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      titleMedium: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      bodyLarge: TextStyle(
        fontSize: 24.0,
        color: UIColors.lightTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: UIColors.lightTextColor,
      ),
      labelLarge: TextStyle(
        color: UIColors.accent,
        fontFamily: UIFonts.hkMontserrat,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    ),
  );

  static ThemeData phoneLightTheme = ThemeData(
    // Default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.indigo.shade900,
    scaffoldBackgroundColor: UIColors.lightBackgroundColor,
    dividerColor: UIColors.lightBorderColor,
    shadowColor: UIColors.white,

    // Color scheme for consistent theming
    colorScheme: const ColorScheme.light(
      primary: Colors.indigo,
      surface: UIColors.lightBackgroundColor,
      onSurface: UIColors.lightTextColor,
      surfaceContainerHighest: UIColors.lightBorderColor,
      onSurfaceVariant: UIColors.lightTextColorSecondary,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: UIColors.lightBackgroundColor,
      iconTheme: IconThemeData(color: UIColors.lightTextColor),
    ),

    // Drawer theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: UIColors.lightBackgroundColor,
    ),

    // Default font family.
    fontFamily: UIFonts.hkMontserrat,

    // Custom theme extensions
    extensions: const <ThemeExtension<dynamic>>[
      ElevatedContainerTheme.light,
    ],

    // Default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and etc.
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: UIColors.black, // Inverted from white
      ),
      displayMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightTextColorSecondary,
      ),
      displaySmall: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: UIColors.lightTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      titleMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: UIColors.lightTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: UIColors.accent,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.0,
        color: UIColors.lightTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: UIColors.lightTextColor,
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
