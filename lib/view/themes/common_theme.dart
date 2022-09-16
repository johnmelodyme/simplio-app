import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

class CommonTheme {
  CommonTheme._();

  static String get fontFamily => 'Karla';

  static EdgeInsetsGeometry get padding =>
      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);

  static EdgeInsetsGeometry get leftTopRightPadding =>
      const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0);

  static InputBorder get outlineBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 0),
      );

  static ThemeData theme = ThemeData(
    fontFamily: fontFamily,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
          (states) => const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
        ),
        textStyle: MaterialStateTextStyle.resolveWith(
          (states) => TextStyle(
            fontSize: 16,
            fontFamily: fontFamily,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: outlineBorder,
      focusedBorder: outlineBorder,
      errorBorder: outlineBorder,
      focusedErrorBorder: outlineBorder,
      contentPadding: Paddings.horizontal20,
    ),
  );
}
