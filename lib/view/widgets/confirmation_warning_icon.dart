import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/helpers/custom_painters.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class ConfirmationWarningIcon extends StatelessWidget {
  final double _innerRadius = 70;

  const ConfirmationWarningIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomPaint(
          painter: LinePainter(
            start: Offset(-_innerRadius / 2, 0),
            end: Offset(_innerRadius / 2, 0),
            color: SioColors.softBlack,
            width: 1.5,
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            start: Offset(_innerRadius / 2, 0),
            end: Offset(0, -_innerRadius * sin(pi / 3)),
            color: SioColors.softBlack,
            width: 1.5,
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            start: Offset(0, -_innerRadius * sin(pi / 3)),
            end: Offset(-_innerRadius / 2, 0),
            color: SioColors.softBlack,
            width: 1.5,
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            start: Offset(0, -_innerRadius * sin(pi / 3) * 0.6),
            end: Offset(0, -_innerRadius * sin(pi / 3) * 0.25),
            color: SioColors.whiteBlue,
            width: 3,
          ),
        ),
        CustomPaint(
          painter: LinePainter(
            start: Offset(0, -_innerRadius * sin(pi / 3) * 0.18),
            end: Offset(0, -_innerRadius * sin(pi / 3) * 0.13),
            color: SioColors.whiteBlue,
            width: 3,
          ),
        ),
      ],
    );
  }
}
