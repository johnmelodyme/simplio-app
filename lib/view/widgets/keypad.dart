import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/keypad_item.dart';

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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        minHeight: rows.length * 59,
      ),
      child: Padding(
        padding: Paddings.horizontal5,
        child: Column(
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
              )
          ],
        ),
      ),
    );
  }
}

class Numpad extends StatelessWidget {
  final bool displayProceedButton;
  final bool displayEraseButton;
  final ValueChanged<int> onTap;
  final VoidCallback? onProceed;
  final VoidCallback? onErase;
  final VoidCallback? onDecimalDotTap;
  final bool isDecimal;

  const Numpad({
    super.key,
    required this.onTap,
    this.onProceed,
    this.onErase,
    this.displayProceedButton = false,
    this.displayEraseButton = false,
    this.onDecimalDotTap,
    this.isDecimal = false,
  }) : assert(isDecimal && onDecimalDotTap != null || !isDecimal,
            'onDecimalDotTap needs to be specified when isDecimal is true');

  @override
  Widget build(BuildContext context) {
    final iconColor = SioColors.whiteBlue;

    return _KeypadGrid.builder(
      rows: [
        _KeypadRow(
          children: [
            KeypadItem.number(
              key: const Key('numpad-button-1'),
              value: 1,
              onTap: onTap,
            ),
            KeypadItem.number(
              key: const Key('numpad-button-2'),
              value: 2,
              onTap: onTap,
            ),
            KeypadItem.number(
              key: const Key('numpad-button-3'),
              value: 3,
              onTap: onTap,
            ),
          ],
        ),
        _KeypadRow(
          children: [
            KeypadItem.number(
              key: const Key('numpad-button-4'),
              value: 4,
              onTap: onTap,
            ),
            KeypadItem.number(
              key: const Key('numpad-button-5'),
              value: 5,
              onTap: onTap,
            ),
            KeypadItem.number(
              key: const Key('numpad-button-6'),
              value: 6,
              onTap: onTap,
            ),
          ],
        ),
        _KeypadRow(
          children: [
            KeypadItem.number(
              key: const Key('numpad-button-7'),
              value: 7,
              onTap: onTap,
            ),
            KeypadItem.number(
              key: const Key('numpad-button-8'),
              value: 8,
              onTap: onTap,
            ),
            KeypadItem.number(
              key: const Key('numpad-button-9'),
              value: 9,
              onTap: onTap,
            ),
          ],
        ),
        isDecimal
            ? _KeypadRow(
                children: [
                  KeypadItem.decimal(
                    key: const Key('numpad-button-decimal-dot'),
                    onTap: onDecimalDotTap!,
                    context: context,
                  ),
                  KeypadItem.number(
                    key: const Key('numpad-button-0'),
                    value: 0,
                    onTap: onTap,
                  ),
                  KeypadItem.action(
                    key: const Key('numpad-action-erase'),
                    content: Padding(
                      padding: Paddings.top8,
                      child: Icon(Icons.backspace_outlined, color: iconColor),
                    ),
                    onTap: () => onErase?.call(),
                  ),
                ],
              )
            : _KeypadRow(
                children: [
                  displayEraseButton
                      ? KeypadItem.action(
                          key: const Key('numpad-action-erase'),
                          content:
                              Icon(Icons.backspace_outlined, color: iconColor),
                          onTap: () => onErase?.call(),
                        )
                      : const KeypadItem(),
                  KeypadItem.number(
                    key: const Key('numpad-button-0'),
                    value: 0,
                    onTap: onTap,
                  ),
                  displayProceedButton
                      ? KeypadItem.action(
                          key: const Key('numpad-action-proceed'),
                          actionType: ActionButtonType.elevated,
                          content: Icon(Icons.check, color: iconColor),
                          onTap: () => onProceed?.call(),
                        )
                      : const KeypadItem(),
                ],
              )
      ],
    );
  }
}
