import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';

class UnderLinedTextFormFieldDecoration extends InputDecoration {
  UnderLinedTextFormFieldDecoration({
    required String labelText,
    required String hintText,
    Color? fillColor,
    Color? iconColor,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? disabledBorder,
    InputBorder? border,
    FloatingLabelBehavior? floatingLabelBehavior,
    Widget? suffixIcon,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          fillColor: fillColor,
          floatingLabelBehavior:
              floatingLabelBehavior ?? FloatingLabelBehavior.always,
          labelStyle:
              labelStyle ?? const TextStyle(color: SioColorsDark.transparent),
          hintStyle: hintStyle ??
              SioTextStyles.bodyPrimary.apply(
                color: SioColorsDark.secondary5,
              ),
          errorStyle: errorStyle,
          border: border,
          enabledBorder: enabledBorder ??
              const UnderlineInputBorder(
                borderSide: BorderSide(color: SioColorsDark.secondary5),
              ),
          disabledBorder: disabledBorder,
          focusedBorder: focusedBorder ??
              const UnderlineInputBorder(
                borderSide: BorderSide(color: SioColorsDark.whiteBlue),
              ),
          suffixIcon: suffixIcon,
          iconColor: iconColor,
        );
}
