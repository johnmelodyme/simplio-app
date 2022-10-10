import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class HighlightedFormElement extends StatefulWidget {
  final List<Widget> children;
  final HighlightController controller;
  final double clickableHeight;
  final double clickableWidth;
  final VoidCallback onTap;
  final bool debug;

  const HighlightedFormElement({
    super.key,
    required this.children,
    required this.controller,
    required this.clickableHeight,
    this.clickableWidth = double.infinity,
    required this.onTap,
    this.debug = false,
  });

  @override
  State<StatefulWidget> createState() => _HighlightedFormElement();
}

class _HighlightedFormElement extends State<HighlightedFormElement> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapUp: (detail) async {
            widget.controller.select();
            widget.onTap();

            await Future.delayed(const Duration(milliseconds: 50));
            // we need to call this second click which triggers second layer which is now clickable
            // otherwise user would need to click two times
            _transparentClick(detail);
          },
          child: Container(
            width: widget.clickableWidth,
            height: widget.clickableHeight,
            padding: Paddings.horizontal16,
            decoration: BoxDecoration(
              borderRadius: BorderRadii.radius20,
              // this settings is used for development to get correct clickableHeight
              color: widget.debug ? Colors.red : Colors.transparent,
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !widget.controller.highlighted,
          child: Container(
            padding: Paddings.horizontal16,
            decoration: BoxDecoration(
              borderRadius: BorderRadii.radius20,
              gradient: widget.controller.highlighted
                  ? RadialGradient(
                      radius: 10,
                      colors: [
                        SioColors.backGradient4Start,
                        SioColors.secondary6,
                      ],
                    )
                  : null,
            ),
            child: Column(
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }

  void _transparentClick(TapUpDetails detail) {
    Future.delayed(const Duration(milliseconds: 1), () async {
      GestureBinding.instance.handlePointerEvent(
        PointerDownEvent(
          pointer: 1,
          position: detail.globalPosition,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 1));
      GestureBinding.instance.handlePointerEvent(
        PointerUpEvent(
          pointer: 1,
          position: detail.globalPosition,
        ),
      );
    });
  }
}

class HighlightValue {
  final bool highlight;
  const HighlightValue(this.highlight);
}

class HighlightController extends ValueNotifier<HighlightValue> {
  List<HighlightController>? concurrentControllers;

  HighlightController({bool? selected, this.concurrentControllers})
      : super(selected == null
            ? const HighlightValue(false)
            : const HighlightValue(true));

  void select() {
    super.value = const HighlightValue(true);
  }

  void deselectConcurrent() {
    if (concurrentControllers != null && concurrentControllers!.isNotEmpty) {
      for (final element in concurrentControllers!) {
        element.deselect();
      }
    }
  }

  void deselect() {
    super.value = const HighlightValue(false);
  }

  bool get highlighted => value.highlight;
}
