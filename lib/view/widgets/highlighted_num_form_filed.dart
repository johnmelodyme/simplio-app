import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class HighlightedNumFormField extends StatefulWidget {
  final TextEditingController controller;
  final double suffixIconMaxWidth;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final Widget? suffixIcon;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;
  final bool highlighted;
  final bool loading;

  const HighlightedNumFormField({
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
  State<StatefulWidget> createState() => _HighlightedNumFormField();
}

class _HighlightedNumFormField extends State<HighlightedNumFormField> {
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

    final style = SioTextStyles.h3.copyWith(
      color: widget.highlighted ? SioColors.mentolGreen : SioColors.secondary5,
    );

    return TextFormField(
      keyboardType: TextInputType.none,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      focusNode: widget.focusNode,
      style: style,
      cursorColor: SioColors.mentolGreen,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          label: !widget.loading &&
                  !widget.highlighted &&
                  widget.controller.text.isEmpty
              ? const Padding(padding: Paddings.top10, child: Text('0'))
              : const SizedBox.shrink(),
          labelStyle: style,
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
          prefixIcon: widget.loading
              ? Row(
                  children: [
                    SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: SioColors.mentolGreen,
                      ),
                    ),
                    Gaps.gap8,
                    Text(
                      context.locale.common_loading_with_dots,
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.mentolGreen,
                      ),
                    )
                  ],
                )
              : null,
          suffixIcon: widget.suffixIcon),
      controller: !widget.loading ? widget.controller : null,
      initialValue: !widget.loading ? null : '',
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
    );
  }
}
