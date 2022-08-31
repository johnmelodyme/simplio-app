import 'dart:math';

import 'package:flutter/material.dart';

class QrCodeMaskPainter extends CustomPainter {
  QrCodeMaskPainter({
    required this.borderColor,
    required this.maskSide,
  });

  final Color borderColor;
  final MaskSide maskSide;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pathPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Path line = Path();
    line.moveTo(size.width, 0);
    line.cubicTo(
      size.width,
      0,
      0,
      0,
      0,
      size.width,
    );
    line.moveTo(0, size.width);
    line.lineTo(0, size.height - size.width);
    line.moveTo(0, size.height - size.width);
    line.cubicTo(
      0,
      size.height - size.width,
      0,
      size.height,
      size.width,
      size.height,
    );

    _drawRotated(
      canvas,
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      maskSide == MaskSide.left ? 0 : pi,
      () => canvas.drawPath(line, pathPaint),
    );
  }

  void _drawRotated(
    Canvas canvas,
    Offset center,
    double angle,
    VoidCallback drawFunction,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum MaskSide { left, right }
