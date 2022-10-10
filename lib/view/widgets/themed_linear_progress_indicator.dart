import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class ThemedLinearProgressIndicator extends StatelessWidget {
  final double? value;

  const ThemedLinearProgressIndicator({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: SioColors.whiteBlue,
      backgroundColor: SioColors.secondary1,
      value: value,
    );
  }
}
