import 'package:flutter/material.dart';

class SioTextStyles {
  static const String _fontFamilyHeaders = "Syne";
  static const String _fontFamilyButton = "Syne";
  static const String _fontFamilyBody = "Karla";
  static const String _fontFamilySubtitle = "Karla";

  //static const TextStyle genericTextStyle = TextStyle(color: SioColors.whiteBlue);

  static TextStyle buttonStyle = const TextStyle(
    fontFamily: _fontFamilyButton,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodyStyle = const TextStyle(
    fontFamily: _fontFamilyBody,
    fontWeight: FontWeight.w400,
  );

  static TextStyle headingStyle = const TextStyle(
    fontFamily: _fontFamilyHeaders,
    fontWeight: FontWeight.w700,
  );

  static TextStyle subtitleStyle = const TextStyle(
    fontFamily: _fontFamilySubtitle,
    fontWeight: FontWeight.w300,
  );

  static TextStyle bodyPrimary = bodyStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.4,
  );

  static TextStyle bodyL = bodyStyle.copyWith(
    fontSize: 14,
    height: 1.36,
  );

  static TextStyle bodyLargeBold = bodyStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.36,
  );

  static TextStyle bodyS = bodyStyle.copyWith(
    fontSize: 12,
    height: 1.42,
  );
  static TextStyle bodyDetail = bodyStyle.copyWith(
    fontSize: 11,
    height: 1.36,
  );

  static TextStyle h1 = headingStyle.copyWith(
    fontSize: 26,
    height: 1.3,
  );
  static TextStyle h2 = headingStyle.copyWith(
    fontSize: 24,
    height: 1.21,
  );

  static TextStyle h3 = headingStyle.copyWith(
    fontSize: 18,
    height: 1.28,
  );

  static TextStyle h4 = headingStyle.copyWith(
    fontSize: 15,
    height: 1.33,
  );

  static TextStyle h5 = headingStyle.copyWith(
    fontSize: 14,
    height: 1.29,
  );

  static TextStyle h6 = headingStyle.copyWith(
    fontSize: 12,
    height: 1.33,
  );

  static TextStyle s1 = subtitleStyle.copyWith(
    fontSize: 17,
    height: 1.47,
  );

  static TextStyle s2 = subtitleStyle.copyWith(
    fontSize: 16,
    height: 1.5,
  );
}
