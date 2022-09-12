import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SioTextStyles {
  static const TextStyle genericTextStyle = TextStyle(color: SioColors.white);

  static TextStyle headingStyle =
      genericTextStyle.copyWith(fontWeight: FontWeight.w400);
  static TextStyle subtitleStyle = genericTextStyle.copyWith(height: 1.3);
  static TextStyle bodyStyle =
      genericTextStyle.copyWith(fontWeight: FontWeight.w400);
  static TextStyle labelStyle =
      genericTextStyle.copyWith(fontWeight: FontWeight.w400);
  static TextStyle buttonStyle =
      genericTextStyle.copyWith(fontWeight: FontWeight.w600);
  static TextStyle allCapsStyle =
      genericTextStyle.copyWith(fontWeight: FontWeight.w400);
  static TextStyle allCapsBoldStyle = genericTextStyle.copyWith();

  static TextStyle headingLarge =
      headingStyle.copyWith(fontSize: 32, height: 1.25);
  static TextStyle h1 = headingStyle.copyWith(fontSize: 22, height: 1.27);
  static TextStyle h2 = headingStyle.copyWith(
      fontSize: 22, height: 1.27, fontWeight: FontWeight.w700);

  static TextStyle h4 = headingStyle.copyWith(
      fontSize: 15, height: 1.11, fontWeight: FontWeight.w700);

  static TextStyle h5 = headingStyle.copyWith(
      fontSize: 14, height: 1.07, fontWeight: FontWeight.bold);

  static TextStyle bodyPrimary = bodyStyle.copyWith(fontSize: 15, height: 1.4);
  static TextStyle bodyL = bodyStyle.copyWith(fontSize: 15, height: 1.33);
  static TextStyle bodyM = bodyStyle.copyWith(fontSize: 14, height: 1.43);
  static TextStyle bodyS = bodyStyle.copyWith(fontSize: 12, height: 1.3);
  static TextStyle bodyLabel = bodyStyle.copyWith(fontSize: 10, height: 1.2);

  static TextStyle navTitle = const TextStyle(
      color: SioColors.white, fontSize: 16, fontWeight: FontWeight.bold);
}
