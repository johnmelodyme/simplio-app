import 'package:flutter/material.dart';
import 'package:simplio_app/view/helpers/custom_painters.dart';

class SuccessCheckIcon extends StatelessWidget {
  final double _innerRadius = 45;
  final double _outerRadius = 70;

  const SuccessCheckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: _innerRadius,
        width: _innerRadius,
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.background, width: 2),
          shape: BoxShape.circle,
        ),
      ),
      Container(
        height: _outerRadius,
        width: _outerRadius,
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.background, width: 2),
          shape: BoxShape.circle,
        ),
      ),
      Icon(
        Icons.check,
        size: 24,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      CustomPaint(
        painter: LinePainter(
          start: Offset(_innerRadius / 2, 0),
          end: Offset(_outerRadius * 0.66, 0),
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      CustomPaint(
        painter: LinePainter(
          start: Offset(-_innerRadius / 2, 0),
          end: Offset(-_outerRadius * 0.66, 0),
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      CustomPaint(
        painter: LinePainter(
          start: Offset(0, _innerRadius / 2),
          end: Offset(0, _outerRadius * 0.66),
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      CustomPaint(
        painter: LinePainter(
          start: Offset(0, -_innerRadius / 2),
          end: Offset(0, -_outerRadius * 0.66),
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    ]);
  }
}
