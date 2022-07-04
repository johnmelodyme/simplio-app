import 'package:flutter/material.dart';

class CommonTheme {
  CommonTheme._();

  static String get fontFamily => 'Roboto';

  static BorderRadius get borderRadius =>
      const BorderRadius.all(Radius.circular(12));

  static EdgeInsetsGeometry get padding =>
      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);

  static EdgeInsetsGeometry get horizontalPadding =>
      const EdgeInsets.symmetric(horizontal: 20.0);

  static EdgeInsetsGeometry get paddingAll => const EdgeInsets.all(20.0);

  static ThemeData theme = ThemeData(
    fontFamily: fontFamily,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
              (states) =>
          const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
        ),
        textStyle: MaterialStateTextStyle.resolveWith(
              (states) =>
              TextStyle(
                fontSize: 16,
                fontFamily: fontFamily,
              ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 0),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 18.0),
    ),
  );
}
