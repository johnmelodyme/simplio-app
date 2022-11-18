import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/themed_linear_progress_indicator.dart';

const double indicatorHeight = 2;
const double indicatorWidth = 31;
const double indicatorPadding = 5;

class Story extends StatefulWidget {
  final List<Widget> items;
  final Widget? bottomNavigationBar;
  final Duration itemDuration;
  final bool repeat;

  const Story({
    super.key,
    required this.items,
    this.itemDuration = const Duration(seconds: 3),
    this.repeat = false,
    this.bottomNavigationBar,
  });

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  int displayedItemIndex = 0;
  bool ignoreStatusListener = false;

  @override
  Widget build(BuildContext context) {
    final bars = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.items
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: _progressIndicatorPadding(e.key, widget.items.length),
              child: ClipRRect(
                borderRadius: BorderRadii.radius2,
                child: SizedBox(
                  height: indicatorHeight,
                  width: indicatorWidth,
                  child: ThemedLinearProgressIndicator(
                    value: controllers[e.key].value,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );

    return Column(
      children: [
        Gaps.gap16,
        bars,
        const Gap(46),
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => _toggleAnimation(),
            onLongPressEnd: (_) => _toggleAnimation(stop: false),
            onTapUp: _handleLeftRightTaps,
            child: widget.items[displayedItemIndex],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    controllers = widget.items
        .asMap()
        .entries
        .map(
          (e) => AnimationController(
            vsync: this,
            duration: widget.itemDuration,
            animationBehavior: AnimationBehavior.preserve,
          )
            ..addListener(() => setState(() => displayedItemIndex = e.key))
            ..addStatusListener((AnimationStatus status) {
              if (ignoreStatusListener) return;
              if (status == AnimationStatus.completed) {
                if (e.key + 1 < widget.items.length) {
                  controllers[e.key + 1].forward();
                }

                if (widget.repeat && e.key + 1 == widget.items.length) {
                  _resetProgressBars();
                  controllers.first.forward(from: 0);
                }
              }
            }),
        )
        .toList();
    controllers.first.forward();
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  EdgeInsetsGeometry _progressIndicatorPadding(int index, int length) {
    if (index + 1 < length) {
      return const EdgeInsets.only(right: indicatorPadding);
    } else {
      return const EdgeInsets.only();
    }
  }

  void _toggleAnimation({stop = true}) {
    stop
        ? controllers[displayedItemIndex].stop()
        : controllers[displayedItemIndex].forward();
  }

  void _resetProgressBars() {
    for (final controller in controllers) {
      controller.stop();
      controller.value = 0;
    }
  }

  void _handleLeftRightTaps(TapUpDetails details) {
    bool rightTap =
        details.globalPosition.dx > MediaQuery.of(context).size.width / 2;

    if (rightTap) {
      if (displayedItemIndex + 1 < widget.items.length) {
        controllers[displayedItemIndex].value = 1;
        controllers[displayedItemIndex + 1].forward();
        setState(() => displayedItemIndex += 1);
      } else {
        _resetProgressBars();
        controllers[0].forward();
        setState(() => displayedItemIndex = 0);
      }
    } else {
      if (displayedItemIndex > 0) {
        controllers[displayedItemIndex].value = 0;
        controllers[displayedItemIndex - 1].forward(from: 0);
        setState(() => displayedItemIndex -= 1);
      } else {
        ignoreStatusListener = true;
        for (final controller in controllers) {
          controller.stop();
          controller.value = 1;
        }
        ignoreStatusListener = false;
        displayedItemIndex = widget.items.length - 1;
        controllers[displayedItemIndex].forward(from: 0);
      }
    }
  }
}
