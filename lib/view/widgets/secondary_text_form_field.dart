import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/input_decoration_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    var border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primaryContainer,
        width: 2,
      ),
    );

    return TextFormField(
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.primary,
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
      maxLines: maxLines,
    );
  }
}