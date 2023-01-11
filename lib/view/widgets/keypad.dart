import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/back_gradient1.dart';
import 'package:simplio_app/view/widgets/keypad_item.dart';
import 'package:sio_glyphs/sio_icons.dart';

// TODO - find a better name
const int numpadBehaviorRange = 1000;

enum NumpadValue {
  zero(0),
  one(1),
  two(2),
  three(3),
  four(4),
  five(5),
  six(6),
  seven(7),
  eight(8),
  nine(9),
  erase(numpadBehaviorRange + 1),
  decimal(numpadBehaviorRange + 2),
  proceed(numpadBehaviorRange + 3),
  clear(numpadBehaviorRange + 4);

  const NumpadValue(this.value);
  final int value;
}

class _KeypadRow {
  final List<KeypadItem> children;

  _KeypadRow({
    required this.children,
  });
}

class _KeypadGrid extends StatelessWidget {
  final List<_KeypadRow> rows;
  final bool stretchItems;

  const _KeypadGrid(
    this.rows,
    this.stretchItems, {
    super.key,
  });

  const _KeypadGrid.builder({
    Key? key,
    required List<_KeypadRow> rows,
    bool? stretchItems,
  }) : this(
          rows,
          stretchItems ?? false,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final row in rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final item in row.children)
                Expanded(
                  flex: stretchItems ? 1 : 0,
                  child: item,
                )
            ],
          ),
      ],
    );
  }
}

class Numpad extends StatelessWidget {
  final bool displayProceedButton;
  final bool displayEraseButton;
  final bool displayDecimalButton;
  final ValueChanged<NumpadValue> onTap;
  final ValueChanged<NumpadValue>? onLongPress;
  final Widget? child;

  const Numpad({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.displayProceedButton = false,
    this.displayEraseButton = false,
    this.displayDecimalButton = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = SioColors.whiteBlue;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        // TODO - Set dynamic height based on parent
        maxHeight: Constants.panelKeyboardHeightWithButton,
        maxWidth: double.infinity,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(
            RadiusSize.radius20,
          ),
        ),
        child: BackGradient1(
          child: Padding(
            padding: Paddings.horizontal5,
            child: Column(
              children: [
                Expanded(
                  child: _KeypadGrid.builder(
                    rows: [
                      _KeypadRow(
                        children: [
                          KeypadItem.number(
                            key: const Key('numpad-button-1'),
                            value: NumpadValue.one,
                            onTap: onTap,
                          ),
                          KeypadItem.number(
                            key: const Key('numpad-button-2'),
                            value: NumpadValue.two,
                            onTap: onTap,
                          ),
                          KeypadItem.number(
                            key: const Key('numpad-button-3'),
                            value: NumpadValue.three,
                            onTap: onTap,
                          ),
                        ],
                      ),
                      _KeypadRow(
                        children: [
                          KeypadItem.number(
                            key: const Key('numpad-button-4'),
                            value: NumpadValue.four,
                            onTap: onTap,
                          ),
                          KeypadItem.number(
                            key: const Key('numpad-button-5'),
                            value: NumpadValue.five,
                            onTap: onTap,
                          ),
                          KeypadItem.number(
                            key: const Key('numpad-button-6'),
                            value: NumpadValue.six,
                            onTap: onTap,
                          ),
                        ],
                      ),
                      _KeypadRow(
                        children: [
                          KeypadItem.number(
                            key: const Key('numpad-button-7'),
                            value: NumpadValue.seven,
                            onTap: onTap,
                          ),
                          KeypadItem.number(
                            key: const Key('numpad-button-8'),
                            value: NumpadValue.eight,
                            onTap: onTap,
                          ),
                          KeypadItem.number(
                            key: const Key('numpad-button-9'),
                            value: NumpadValue.nine,
                            onTap: onTap,
                          ),
                        ],
                      ),
                      displayDecimalButton
                          ? _KeypadRow(
                              children: [
                                KeypadItem.decimal(
                                  key: const Key('numpad-button-decimal-dot'),
                                  onTap: () => onTap(NumpadValue.decimal),
                                  context: context,
                                ),
                                KeypadItem.number(
                                  key: const Key('numpad-button-0'),
                                  value: NumpadValue.zero,
                                  onTap: onTap,
                                ),
                                KeypadItem.action(
                                  key: const Key('numpad-action-erase'),
                                  content: Padding(
                                    padding: Paddings.top8,
                                    child: Icon(Icons.backspace_outlined,
                                        color: iconColor),
                                  ),
                                  onTap: () => onTap(NumpadValue.erase),
                                  onLongPress: () =>
                                      onLongPress?.call(NumpadValue.clear),
                                ),
                              ],
                            )
                          : _KeypadRow(
                              children: [
                                displayEraseButton
                                    ? KeypadItem.action(
                                        key: const Key('numpad-action-erase'),
                                        content: Icon(Icons.backspace_outlined,
                                            color: iconColor),
                                        onTap: () => onTap(NumpadValue.erase),
                                        onLongPress: () => onLongPress
                                            ?.call(NumpadValue.clear),
                                      )
                                    : const KeypadItem(),
                                KeypadItem.number(
                                  key: const Key('numpad-button-0'),
                                  value: NumpadValue.zero,
                                  onTap: onTap,
                                ),
                                displayProceedButton
                                    ? KeypadItem.action(
                                        key: const Key('numpad-action-proceed'),
                                        actionType: ActionButtonType.elevated,
                                        content: const Icon(SioIcons.done,
                                            color: SioColorsDark.softBlack),
                                        onTap: () => onTap(NumpadValue.proceed),
                                      )
                                    : const KeypadItem(),
                              ],
                            ),
                    ],
                  ),
                ),
                if (child != null) child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
