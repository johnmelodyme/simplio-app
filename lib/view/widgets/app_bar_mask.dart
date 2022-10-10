import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/app_bar_rounded_mask.dart';

class AppBarMask extends StatelessWidget {
  const AppBarMask({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: AppBarMaskPainter(
          startColor: SioColors.softBlack.withOpacity(0.8),
          endColor: SioColors.appBarTop.withOpacity(0.8),
        ),
      ),
    );
  }
}
