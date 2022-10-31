import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class BackGradient1 extends StatelessWidget {
  const BackGradient1({
    super.key,
    required this.child,
    this.topCenterColor,
    this.bottomCenterColor,
  });

  final Widget child;
  final Color? topCenterColor;
  final Color? bottomCenterColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              topCenterColor ?? SioColors.backGradient4Start,
              bottomCenterColor ?? SioColors.softBlack,
            ],
          ),
        ),
        child: child);
  }
}
