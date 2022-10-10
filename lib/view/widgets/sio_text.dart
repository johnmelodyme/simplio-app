import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SioText extends StatelessWidget {
  const SioText({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(color: SioColors.whiteBlue),
    );
  }
}
