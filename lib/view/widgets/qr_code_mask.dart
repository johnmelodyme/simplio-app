import 'package:flutter/material.dart';
import 'package:simplio_app/view/widgets/qr_code_mask_painter.dart';

class QrCodeMask extends StatelessWidget {
  const QrCodeMask({
    super.key,
    required this.maskSide,
    this.width = 20,
  });

  final MaskSide maskSide;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CustomPaint(
        painter: QrCodeMaskPainter(
          borderColor: Theme.of(context).colorScheme.inverseSurface,
          maskSide: maskSide,
        ),
      ),
    );
  }
}
