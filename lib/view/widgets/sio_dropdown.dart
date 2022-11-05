import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/highlighted_form_element.dart';
import 'package:sio_glyphs/sio_icons.dart';

class SioDropdown extends StatefulWidget {
  final HighlightController highlightController;
  final List<Widget> items;
  final Widget? placeholder;
  final int selectedIndex;
  final Function(int selectedIndex) itemSelectedCallback;
  final bool disabled;

  const SioDropdown({
    super.key,
    required this.highlightController,
    this.items = const [],
    this.selectedIndex = -1,
    required this.itemSelectedCallback,
    this.placeholder,
    this.disabled = false,
  });

  @override
  State<StatefulWidget> createState() => _SioDropdown();
}

class _SioDropdown extends State<SioDropdown> {
  final LayerLink layerLink = LayerLink();
  late OverlayEntry overlayEntry = createOverlayEntry;
  late List<Widget> dropdownMappedItems;
  late List<Widget> mappedItems;
  late Widget? mappedPlaceholder;

  late int selectedIndex;

  OverlayEntry get createOverlayEntry {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    final size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadii.radius16,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.center,
                      colors: [
                        SioColors.backGradient4Start,
                        SioColors
                            .backGradient2, // todo: replace with proper color when Theme refactoring is done
                      ],
                    ),
                  ),
                  child: Column(
                    children: dropdownMappedItems,
                  ),
                ),
              ),
            ));
  }

  final padding = const EdgeInsets.symmetric(
      horizontal: Dimensions.padding17, vertical: Dimensions.padding14);

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.center,
      colors: [
        SioColors.backGradient4Start,
        SioColors
            .backGradient2, // todo: replace with proper color when Theme refactoring is done
      ],
    );

    mappedItems = widget.items
        .asMap()
        .entries
        .map(
          (e) => GestureDetector(
            onTap: () {
              if (overlayEntry.mounted) {
                widget.itemSelectedCallback(e.key);
                overlayEntry.remove();
              } else {
                Overlay.of(context)?.insert(overlayEntry);
              }
            },
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadii.radius16,
              ),
              child: e.value,
            ),
          ),
        )
        .toList();

    if (widget.placeholder != null && selectedIndex < 0) {
      mappedPlaceholder = GestureDetector(
        onTap: () {
          if (!widget.disabled) return;

          if (overlayEntry.mounted) {
            overlayEntry.remove();
          } else {
            Overlay.of(context)?.insert(overlayEntry);
          }
        },
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadii.radius16,
          ),
          child: widget.placeholder,
        ),
      );
    }

    dropdownMappedItems = widget.items
        .asMap()
        .entries
        .map((e) => GestureDetector(
              onTap: () {
                if (overlayEntry.mounted) {
                  setState(() {
                    selectedIndex = e.key;
                    widget.itemSelectedCallback(e.key);
                  });

                  Future.delayed(const Duration(milliseconds: 50), () {
                    overlayEntry.remove();
                    Overlay.of(context)?.insert(overlayEntry);
                  });

                  Future.delayed(const Duration(milliseconds: 300),
                      () => overlayEntry.remove());
                } else {
                  Overlay.of(context)?.insert(overlayEntry);
                }
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == e.key ? SioColors.secondary4 : null,
                      gradient: selectedIndex != e.key ? gradient : null,
                      borderRadius: BorderRadii.radius16,
                    ),
                    padding: padding,
                    child: e.value,
                  ),
                  Row(children: [
                    Visibility(
                        visible: false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Padding(
                          padding: padding,
                          child: e.value,
                        )),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: selectedIndex == e.key
                                  ? SioColors.mentolGreen
                                  : null,
                              border: Border.all(
                                width: 1,
                                color: selectedIndex == e.key
                                    ? Colors.transparent
                                    : SioColors.secondary5,
                              ),
                              borderRadius: BorderRadii.radius16,
                            ),
                          )),
                    ),
                    Gaps.gap17,
                  ]),
                ],
              ),
            ))
        .toList();

    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        onTap: () {
          if (Overlay.of(context) == null || !Overlay.of(context)!.mounted) {
            Overlay.of(context)!.insert(overlayEntry);
          }
        },
        child: Stack(children: [
          Row(children: [
            Expanded(
              child: widget.placeholder != null && widget.selectedIndex < 0
                  ? mappedPlaceholder!
                  : mappedItems[selectedIndex],
            ),
          ]),
          Row(children: [
            Visibility(
              visible: false,
              maintainState: true,
              maintainSize: true,
              maintainAnimation: true,
              child: widget.placeholder != null && widget.selectedIndex < 0
                  ? mappedPlaceholder!
                  : mappedItems[selectedIndex],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  SioIcons.arrow_bottom,
                  size: 16,
                  color: SioColors.mentolGreen,
                ),
              ),
            ),
            Gaps.gap14,
          ]),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    selectedIndex = widget.selectedIndex;
    widget.highlightController.addListener(() {
      if (!widget.highlightController.highlighted && overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
