import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/themes/simplio_colors.dart';

class DarkMode {
  DarkMode._();

  static Color get backgroundColor => SioColors.black;

  static Color get buttonColor => SioColors.secondary1;

  static Color get fontColor => SioColors.white;

  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: SioColors.black,
        onPrimary: SioColors.white,
        primaryContainer: SioColors.secondary1,
        secondary: SioColors.highlight1,
        onSecondary: SioColors.black,
        tertiary: SioColors.highlight2,
        error: SioColors.attention,
        onError: Colors.redAccent,
        background: Colors.orangeAccent,
        onBackground: Colors.orange,
        surface: Colors.brown,
        onSurface: Colors.blueAccent,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(color: colorScheme.onPrimary),
        displayMedium: TextStyle(color: colorScheme.onPrimary),
        displaySmall: TextStyle(color: colorScheme.onPrimary),
        headlineLarge: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 32),
        headlineMedium: TextStyle(color: colorScheme.onPrimary),
        headlineSmall: TextStyle(color: colorScheme.onPrimary),
        bodyLarge: TextStyle(color: colorScheme.onPrimary),
        bodyMedium: TextStyle(color: colorScheme.onPrimary),
        bodySmall: TextStyle(color: colorScheme.onPrimary),
        labelLarge: TextStyle(color: colorScheme.onPrimary),
        labelMedium: TextStyle(color: colorScheme.onPrimary),
        labelSmall: TextStyle(color: colorScheme.onPrimary),
        titleLarge: TextStyle(color: colorScheme.onPrimary),
        titleMedium: TextStyle(color: colorScheme.onPrimary),
        titleSmall: TextStyle(color: colorScheme.onPrimary),
      );

  static ThemeData theme = CommonTheme.theme.copyWith(
    colorScheme: colorScheme,
    highlightColor: buttonColor,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      backgroundColor: colorScheme.primary,
      titleTextStyle: TextStyle(
        backgroundColor: colorScheme.primary,
        color: colorScheme.onPrimary,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: buttonColor,
      unselectedItemColor: fontColor,
      selectedItemColor: colorScheme.secondary,
    ),
    inputDecorationTheme: CommonTheme.theme.inputDecorationTheme.copyWith(
      fillColor: colorScheme.onPrimary,
      labelStyle: TextStyle(color: colorScheme.primary),
      iconColor: colorScheme.primary,
      hintStyle: TextStyle(fontSize: 16.0, color: colorScheme.onPrimary),
      border: InputBorder.none,
      errorStyle: TextStyle(
        color: colorScheme.error,
        fontSize: 14,
      ),
    ),
    scaffoldBackgroundColor: backgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: CommonTheme.theme.elevatedButtonTheme.style?.merge(
        ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) =>
              states.isNotEmpty && states.first == MaterialState.pressed
                  ? colorScheme.secondary
                  : buttonColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: CommonTheme.buttonBorderRadius,
            ),
          ),
        ),
      ),
    ),
  );
}
