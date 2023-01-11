import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const GradientContainer({
    super.key,
    this.borderRadius,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            SioColors.backGradient4Start,
            SioColors.backGradient2,
          ],
        ),
        borderRadius: borderRadius ?? BorderRadii.radius20,
      ),
      padding: padding ?? Paddings.all16,
      child: child,
    );
  }
}
