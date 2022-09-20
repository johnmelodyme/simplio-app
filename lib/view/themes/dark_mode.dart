import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/constants.dart';

class DarkMode {
  DarkMode._();

  static Color get backgroundColor => SioColors.black;

  static Color get buttonColor => SioColors.secondary1;

  static Color get fontColor => SioColors.whiteBlue;

  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: SioColors.black,
        onPrimary: SioColors.whiteBlue,
        primaryContainer: SioColors.secondary1,
        onPrimaryContainer: SioColors.backGradient4Start,
        secondary: SioColors.highlight1,
        onSecondary: SioColors.black,
        secondaryContainer: SioColors.confirm,
        onSecondaryContainer: SioColors.secondary6,
        tertiary: SioColors.highlight2,
        onTertiary: SioColors.highlight,
        tertiaryContainer: SioColors.backGradient3Start,
        onTertiaryContainer: SioColors.backGradient3End,
        error: SioColors.attention,
        onError: SioColors.earningStart,
        errorContainer: SioColors.secondary2,
        onErrorContainer: SioColors.backGradient3Start,
        background: SioColors.softBlack,
        onBackground: SioColors.games,
        surface: SioColors.coins,
        onSurface: SioColors.nft,
        surfaceVariant: SioColors.bottomTabBarStartColor,
        onSurfaceVariant: SioColors.bottomTabBarEndColor,
        outline: SioColors.secondary4,
        shadow: SioColors.secondary7,
        inverseSurface: SioColors.mentolGreen,
        onInverseSurface: SioColors.backGradient3End,
        surfaceTint: SioColors.secondary5,
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
        bodyLarge: TextStyle(color: colorScheme.onPrimary, fontSize: 18),
        bodyMedium: TextStyle(color: colorScheme.onPrimary, fontSize: 16),
        bodySmall: TextStyle(color: colorScheme.onPrimary, fontSize: 14),
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
              borderRadius: BorderRadiuses.radius6,
            ),
          ),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: backgroundColor,
      actionTextColor: fontColor,
      contentTextStyle: TextStyle(color: fontColor),
    ),
    canvasColor: backgroundColor,
  );
}
