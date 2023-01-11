import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class ValueFormField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? child;
  final TextStyle? textStyle;
  final bool isFocused;
  final VoidCallback? onTap;

  const ValueFormField({
    super.key,
    this.label = '',
    required this.value,
    this.textStyle,
    this.child,
    this.isFocused = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        TextStyle(
          fontSize: 20,
          color: SioColors.secondary7,
        );

    return Container(
      height: 46,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isFocused ? SioColors.mentolGreen : SioColors.secondary4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.isEmpty ? label : value,
                      style: isFocused
                          ? style.copyWith(color: SioColors.mentolGreen)
                          : style,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.padding16,
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
