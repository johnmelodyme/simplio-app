import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class HighlightedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final double suffixIconMaxWidth;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final Widget? suffixIcon;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;
  final bool highlighted;
  final bool loading;

  const HighlightedTextFormField({
    super.key,
    required this.controller,
    this.suffixIconMaxWidth = 135,
    this.onChanged,
    this.maxLines = 1,
    this.suffixIcon,
    required this.highlighted,
    this.onTap,
    this.focusNode,
    this.loading = false,
  });

  @override
  State<StatefulWidget> createState() => _HighlightedTextFormField();
}

class _HighlightedTextFormField extends State<HighlightedTextFormField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(
        color:
            widget.highlighted ? SioColors.mentolGreen : SioColors.secondary4,
      ),
    );

    return TextFormField(
      focusNode: widget.focusNode,
      style: SioTextStyles.bodyPrimary.apply(
        color: SioColors.whiteBlue,
      ),
      cursorColor: SioColors.mentolGreen,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          fillColor: Colors.transparent,
          contentPadding: Paddings.bottom5,
          isDense: true,
          enabledBorder: border,
          focusedBorder: border,
          border: border,
          suffixIconConstraints: BoxConstraints(
            maxWidth: widget.suffixIconMaxWidth,
          ),
          prefixIconConstraints: const BoxConstraints(maxHeight: 18),
          suffixIcon: widget.suffixIcon),
      controller: !widget.loading ? widget.controller : null,
      initialValue: !widget.loading ? null : '',
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
    );
  }
}
