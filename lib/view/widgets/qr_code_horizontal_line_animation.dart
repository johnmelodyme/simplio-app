import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class QrCodeHorizontalLineAnimation extends StatefulWidget {
  const QrCodeHorizontalLineAnimation({
    super.key,
    this.dividerWidth = 10,
  });

  final double dividerWidth;

  @override
  State<QrCodeHorizontalLineAnimation> createState() =>
      _QrCodeHorizontalLineAnimationState();
}

class _QrCodeHorizontalLineAnimationState
    extends State<QrCodeHorizontalLineAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  late final Animation<AlignmentGeometry> _alignmentAnimation =
      Tween<AlignmentGeometry>(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).animate(_animationController);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AlignTransition(
        alignment: _alignmentAnimation,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.padding8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: SioColors.whiteBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: SioColors.mentolGreen.withOpacity(0.5),
                      spreadRadius: 20,
                      blurRadius: 20,
                      offset: const Offset(1, 1),
                    ),
                    BoxShadow(
                      color: SioColors.mentolGreen.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
