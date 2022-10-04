import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final double width;

  const LinePainter({
    required this.color,
    required this.start,
    required this.end,
    this.width = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = color;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;
}

class CirclePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  const CirclePainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SioTextPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final Offset offset;

  const SioTextPainter({
    required this.style,
    required this.text,
    this.offset = const Offset(0, 0),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: style,
        ),
        textDirection: TextDirection.ltr)
      ..layout();

    final textSpanRect =
        Alignment.center.inscribe(textPainter.size, Offset.zero & size);

    textPainter.paint(canvas, textSpanRect.topLeft + offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
