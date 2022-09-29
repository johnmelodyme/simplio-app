import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AppBarMaskPainter extends CustomPainter {
  AppBarMaskPainter({
    required this.startColor,
    required this.endColor,
  });

  final Color startColor;
  final Color endColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = const Offset(0, 0) & size;

    final Paint pathPaint = Paint()
      ..blendMode = BlendMode.color
      ..shader = ui.Gradient.linear(
        rect.topCenter,
        rect.bottomCenter,
        [
          startColor,
          endColor,
        ],
      );

    final Path line = Path();
    line.moveTo(0, 0);
    line.lineTo(0, size.height);
    line.cubicTo(
      0,
      size.height,
      0,
      size.height - 20,
      20,
      size.height - 20,
    );

    line.lineTo(size.width - 20, size.height - 20);

    line.cubicTo(
      size.width - 20,
      size.height - 20,
      size.width,
      size.height - 20,
      size.width,
      size.height,
    );

    line.lineTo(size.width, 0);

    line.close();

    canvas.drawPath(line, pathPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
