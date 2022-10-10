import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/input_decoration_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SecondaryTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final double suffixIconMaxWidth;
  final EdgeInsetsGeometry contentPadding;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final bool readOnly;
  final GestureTapCallback? onTap;

  const SecondaryTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.suffixIconMaxWidth = 135,
    this.contentPadding = Paddings.vertical20,
    this.onChanged,
    this.maxLines = 1,
    this.suffixIcon,
    this.decoration,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: SioColors.secondary1,
        width: 2,
      ),
    );

    return TextFormField(
      style: TextStyle(color: SioColors.whiteBlue),
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      decoration: InputDecoration(
              fillColor: SioColors.black,
              contentPadding: contentPadding,
              enabledBorder: border,
              focusedBorder: border,
              border: border,
              suffixIconConstraints: BoxConstraints(
                maxWidth: suffixIconMaxWidth,
              ),
              suffixIcon: suffixIcon)
          .merge(decoration),
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines,
    );
  }
}
