import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

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
              color: inverseColor ? SioColors.softBlack : SioColors.whiteBlue)
          .merge(SioTextStyles.buttonStyle)
          .merge(style),
    );
  }
}
