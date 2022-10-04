import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class SwipeUpButton extends StatefulWidget {
  static const double _defaultHeight = 400;
  static const double _defaultSwipeHeight = 1000;
  static const double _defaultSwipePercentageNeeded = 0.75;

  const SwipeUpButton(
    this.data, {
    super.key,
    this.height = _defaultHeight,
    this.swipeHeight = _defaultSwipeHeight,
    this.swipePercentageNeeded = _defaultSwipePercentageNeeded,
    required this.onSwipeCallback,
  });

  final String data;
  final double height;
  final double swipeHeight;
  final VoidCallback onSwipeCallback;
  final double? swipePercentageNeeded;

  @override
  State<StatefulWidget> createState() => _SwipeUpButton();
}

class _SwipeUpButton extends State<SwipeUpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late double initControllerVal;

  double startY = 0.0;
  double endY = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => {
        setState(() {
          startY = details.localPosition.dy;
        })
      },
      onPanUpdate: (details) {
        setState(() {
          endY = details.localPosition.dy;
          animationController.value = max(
              2 * (startY - endY) / (widget.swipeHeight), initControllerVal);
        });
      },
      onPanEnd: (details) {
        final delta = startY - endY;
        final deltaNeededToBeSwiped =
            widget.height * widget.swipePercentageNeeded!;

        if (delta > deltaNeededToBeSwiped) {
          animationController.animateTo(6,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
          widget.onSwipeCallback();
        } else {
          animationController.animateTo(initControllerVal,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
        }
      },
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: animationController.value,
          widthFactor: 1.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.topLeft,
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.inverseSurface,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(RadiusSize.radius20),
                topRight: Radius.circular(RadiusSize.radius20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gaps.gap10,
                const Icon(
                  Icons.rocket,
                  size: 48,
                ),
                Gaps.gap10,
                Text(
                  widget.data,
                  style: SioTextStyles.buttonLarge.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Gaps.gap48,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initControllerVal = widget.height / widget.swipeHeight;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(
        () {
          if (animationController.value > initControllerVal) {
            setState(() {});
          }
        },
      );

    animationController.value = initControllerVal;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
