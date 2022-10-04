import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class ThemedText extends StatelessWidget {
  final String text;
  final bool inverseColor;
  final TextStyle? style;

  const ThemedText(
    this.text, {
    this.inverseColor = false,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
              color: inverseColor
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.onPrimary)
          .merge(SioTextStyles.buttonStyle)
          .merge(style),
    );
  }
}
