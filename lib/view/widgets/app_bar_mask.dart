import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/app_bar_rounded_mask.dart';

class AppBarMask extends StatelessWidget {
  const AppBarMask({
    super.key,
    required this.height,
    required this.offset,
  });

  final double height;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: AppBarRoundedMaskPainter(
          color: SioColors.softBlack,
          offset: offset,
        ),
      ),
    );
  }
}
