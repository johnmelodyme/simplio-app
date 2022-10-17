import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/themes/sio_colors_light.dart';

bool? isAuthenticated;
ThemeMode? globalThemeMode;

abstract class SioColors {
  static bool isDarkMode() {
    final isDarkMode =
        isAuthenticated != true || globalThemeMode != ThemeMode.light;
    return isDarkMode;
  }

  static Color get white =>
      isDarkMode() ? SioColorsDark.white : SioColorsLight.white;
  static Color get whiteBlue =>
      isDarkMode() ? const Color(0xFFF1F7FA) : const Color(0xFF000000);
  static Color get transparent => Colors.transparent;

  static Color get black =>
      isDarkMode() ? SioColorsDark.black : SioColorsLight.black;
  static Color get backGradient4Start => isDarkMode()
      ? SioColorsDark.backGradient4Start
      : SioColorsLight.backGradient4Start;
  static Color get appBarTop =>
      isDarkMode() ? SioColorsDark.appBarTop : SioColorsLight.appBarTop;
  static Color get softBlack =>
      isDarkMode() ? SioColorsDark.softBlack : SioColorsLight.softBlack;
  static Color get secondary0 =>
      isDarkMode() ? SioColorsDark.secondary0 : SioColorsLight.secondary0;
  static Color get secondary1 =>
      isDarkMode() ? SioColorsDark.secondary1 : SioColorsLight.secondary1;
  static Color get secondary2 =>
      isDarkMode() ? SioColorsDark.secondary2 : SioColorsLight.secondary2;
  static Color get secondary4 =>
      isDarkMode() ? SioColorsDark.secondary4 : SioColorsLight.secondary4;
  static Color get secondary5 =>
      isDarkMode() ? SioColorsDark.secondary5 : SioColorsLight.secondary5;
  static Color get secondary6 =>
      isDarkMode() ? SioColorsDark.secondary6 : SioColorsLight.secondary6;
  static Color get secondary7 =>
      isDarkMode() ? SioColorsDark.secondary7 : SioColorsLight.secondary7;

  static Color get attention =>
      isDarkMode() ? SioColorsDark.attention : SioColorsLight.attention;
  static Color get confirm =>
      isDarkMode() ? SioColorsDark.confirm : SioColorsLight.confirm;

  static Color get highlight1 =>
      isDarkMode() ? SioColorsDark.highlight1 : SioColorsLight.highlight1;

  static Color get highlight =>
      isDarkMode() ? SioColorsDark.highlight : SioColorsLight.highlight;
  static Color get mentolGreen =>
      isDarkMode() ? SioColorsDark.mentolGreen : SioColorsLight.mentolGreen;
  static Color get coins =>
      isDarkMode() ? SioColorsDark.coins : SioColorsLight.coins;
  static Color get nft => isDarkMode() ? SioColorsDark.nft : SioColorsLight.nft;
  static Color get games =>
      isDarkMode() ? SioColorsDark.games : SioColorsLight.games;
  static Color get earningStart =>
      isDarkMode() ? SioColorsDark.earningStart : SioColorsLight.earningStart;

  static Color get vividBlue =>
      isDarkMode() ? SioColorsDark.vividBlue : SioColorsLight.vividBlue;

  static Color get appBarStartColor => isDarkMode()
      ? SioColorsDark.appBarStartColor
      : SioColorsLight.appBarStartColor;
  static Color get appBarEndColor => isDarkMode()
      ? SioColorsDark.appBarEndColor
      : SioColorsLight.appBarEndColor;

  static Color get bottomTabBarStartColor => isDarkMode()
      ? SioColorsDark.bottomTabBarStartColor
      : SioColorsLight.bottomTabBarStartColor;
  static Color get bottomTabBarEndColor => isDarkMode()
      ? SioColorsDark.bottomTabBarEndColor
      : SioColorsLight.bottomTabBarEndColor;

  static Color get blackGradient2 => isDarkMode()
      ? SioColorsDark.blackGradient2
      : SioColorsLight.blackGradient2;

  static Color get backGradient3Start => isDarkMode()
      ? SioColorsDark.backGradient3Start
      : SioColorsLight.backGradient3Start;
  static Color get backGradient3End => isDarkMode()
      ? SioColorsDark.backGradient3End
      : SioColorsLight.backGradient3End;

  static Color get attentionGradient => isDarkMode()
      ? SioColorsDark.attentionGradient
      : SioColorsLight.attentionGradient;

  static Color get gameItemStartGradient => isDarkMode()
      ? SioColorsDark.gameItemStartGradient
      : SioColorsLight.gameItemStartGradient;

  static Color get gameItemEndGradient => isDarkMode()
      ? SioColorsDark.gameItemEndGradient
      : SioColorsLight.gameItemEndGradient;
}
