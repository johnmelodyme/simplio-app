import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class BackGradient2 extends StatelessWidget {
  const BackGradient2({
    super.key,
    required this.child,
    this.topLeftColor,
    this.bottomRightColor,
  });

  final Widget child;
  final Color? bottomRightColor;
  final Color? topLeftColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              topLeftColor ?? SioColors.backGradient4Start,
              bottomRightColor ?? SioColors.blackGradient2,
            ],
          ),
        ),
        child: child);
  }
}
