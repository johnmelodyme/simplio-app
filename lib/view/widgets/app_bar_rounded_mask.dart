import 'package:flutter/material.dart';

class AppBarRoundedMaskPainter extends CustomPainter {
  AppBarRoundedMaskPainter({
    required this.color,
    required this.offset,
  });

  final double offset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pathPaint = Paint()..color = color;

    final Path topLeftRect = _getTopLeftPath(size);
    final Path topRightRect = _getTopRightPath(size);

    canvas.drawPath(topLeftRect, pathPaint);
    canvas.drawPath(topRightRect, pathPaint);
  }

  Path _getTopLeftPath(Size size) {
    final Path line = Path();
    line.moveTo(0, size.height);
    line.cubicTo(
      0,
      size.height,
      0,
      0,
      offset,
      0,
    );

    line.lineTo(offset, size.height);
    line.lineTo(0, size.height);
    line.close();

    return line;
  }

  Path _getTopRightPath(Size size) {
    final Path line = Path();
    line.moveTo(size.width - offset, 0);
    line.cubicTo(
      size.width - offset,
      0,
      size.width,
      0,
      size.width,
      size.height,
    );

    line.lineTo(size.width - offset, size.height);
    line.lineTo(size.width - offset, 0);
    line.close();

    return line;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
