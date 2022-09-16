import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

class SwipeUpButton extends StatefulWidget {
  const SwipeUpButton({
    super.key,
    required this.child,
    required this.height,
    required this.swipeHeight,
    required this.onSwipeCallback,
    required this.onSwipeStartCallback,
    this.swipePercentageNeeded = 0.75,
  });

  final Widget child;
  final double height;
  final double swipeHeight;
  final VoidCallback onSwipeCallback;
  final Function(bool, double) onSwipeStartCallback;
  final double? swipePercentageNeeded;

  @override
  State<StatefulWidget> createState() => _SwipeUpButton();
}

class _SwipeUpButton extends State<SwipeUpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late double initControllerVal;

  var startY = 0.0;
  var endY = 0.0;

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
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: const BorderRadius.all(
                Radius.circular(RadiusSize.radius12),
              ),
            ),
            child: widget.child,
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
            widget.onSwipeStartCallback(
                animationController.value > initControllerVal + 0.1,
                animationController.value);
          }
          if (animationController.value == initControllerVal) {
            widget.onSwipeStartCallback(false, 0);
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
