import 'package:flutter/material.dart';

class ThemedTextFormField extends StatelessWidget {
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChange;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextEditingController? controller;
  final int? maxLines;
  final TextAlignVertical? textAlignVertical;

  const ThemedTextFormField({
    super.key,
    this.autofocus = false,
    this.validator,
    this.decoration,
    this.onChanged,
    this.keyboardType,
    this.style,
    this.onFocusChange,
    this.controller,
    this.maxLines,
    this.textAlignVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextFormField(
        key: key,
        controller: controller,
        autofocus: autofocus,
        validator: validator,
        decoration: decoration,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ).merge(style),
      ),
    );
  }
}
