import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class BackGradient4 extends StatelessWidget {
  const BackGradient4({
    super.key,
    required this.child,
    this.topRightColor,
    this.centerColor,
  });

  final Widget child;
  final Color? centerColor;
  final Color? topRightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.center,
            colors: [
              topRightColor ?? SioColors.backGradient4Start,
              centerColor ?? SioColors.softBlack,
            ],
          ),
        ),
        child: child);
  }
}
