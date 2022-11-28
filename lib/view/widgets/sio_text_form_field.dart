import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SioTextFormField extends StatefulWidget {
  final Key? textFormKey;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChange;
  final TextInputType? keyboardType;
  final TextStyle? focusedStyle;
  final TextStyle? unfocusedStyle;
  final TextEditingController? controller;
  final int? maxLines;
  final TextAlignVertical? textAlignVertical;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;

  const SioTextFormField({
    super.key,
    this.textFormKey,
    this.autofocus = false,
    this.validator,
    this.decoration,
    this.onChanged,
    this.keyboardType,
    this.focusedStyle,
    this.unfocusedStyle,
    this.onFocusChange,
    this.controller,
    this.maxLines,
    this.textAlignVertical,
    this.cursorColor,
    this.inputFormatters,
  });

  @override
  State<SioTextFormField> createState() => _SioTextFormFieldState();
}

class _SioTextFormFieldState extends State<SioTextFormField> {
  FocusNode focusNode = FocusNode();
  late TextStyle? focusedStyle;
  late TextStyle? unfocusedStyle;

  @override
  void initState() {
    focusedStyle = widget.focusedStyle ??
        SioTextStyles.bodyPrimary.apply(color: SioColors.whiteBlue);
    unfocusedStyle = widget.unfocusedStyle ??
        SioTextStyles.bodyPrimary.apply(color: SioColors.secondary7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        widget.onFocusChange?.call(focused);
        setState(() {});
      },
      child: TextFormField(
        key: widget.textFormKey,
        focusNode: focusNode,
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        autofocus: widget.autofocus,
        validator: widget.validator,
        decoration: widget.decoration,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        textAlignVertical: widget.textAlignVertical,
        cursorColor: widget.cursorColor,
        style: TextStyle(
          color: SioColors.black,
        ).merge(
            focusNode.hasFocus ? widget.focusedStyle : widget.unfocusedStyle),
      ),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
