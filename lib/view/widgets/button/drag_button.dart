import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class DragButton extends StatefulWidget {
  final String? label;
  final IconData icon;
  final double height;
  final Duration duration;
  final AsyncCallback onDrag;
  final List<Widget> children;
  final Widget child;

  const DragButton({
    super.key,
    this.label,
    required this.icon,
    this.height = 200,
    this.duration = const Duration(milliseconds: 200),
    required this.onDrag,
    required this.child,
    this.children = const [],
  });

  @override
  State<DragButton> createState() => _DragButtonState();
}

class _DragButtonState extends State<DragButton> with TickerProviderStateMixin {
  late double _height;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _height = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final threshold = viewportHeight / 2;

    bool isDragged = _height >= viewportHeight;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: widget.height,
          ),
          child: Column(
            children: widget.children,
          ),
        ),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _height > widget.height ? 1 : 0,
            duration: widget.duration,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragStart: (_) => setState(() {
              _isDragging = true;
            }),
            onVerticalDragUpdate: (details) {
              final maxHeight = viewportHeight - (viewportHeight / 100 * 20);
              if (_height > maxHeight) return;

              setState((() {
                _height = max(
                  widget.height,
                  min(_height - details.delta.dy, maxHeight),
                );
              }));
            },
            onVerticalDragEnd: (_) => setState(() {
              _isDragging = false;
              _height = _height >= threshold ? viewportHeight : widget.height;
            }),
            child: AnimatedContainer(
              height: _height,
              duration: _isDragging ? Duration.zero : widget.duration,
              curve: Curves.fastOutSlowIn,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      SioColors.highlight1,
                      SioColors.vividBlue,
                    ],
                  ),
                  borderRadius: isDragged ? null : BorderRadii.radius30,
                  color: SioColors.mentolGreen,
                ),
                child: isDragged
                    ? widget.child
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            widget.icon,
                            size: 46,
                          ),
                          if (widget.label != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 10,
                              ),
                              child: AnimatedOpacity(
                                opacity: _height > threshold ? 0 : 1,
                                duration: widget.duration,
                                child: Text(
                                  widget.label!,
                                  style: SioTextStyles.h4,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
