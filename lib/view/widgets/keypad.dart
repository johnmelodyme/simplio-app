import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
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
        minWidth: double.infinity,
      ),
      child: Padding(
        padding: CommonTheme.paddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var row in rows)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var item in row.children)
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

  const Numpad({
    super.key,
    required this.onTap,
    this.onProceed,
    this.onErase,
    this.displayProceedButton = false,
    this.displayEraseButton = false,
  });

  @override
  Widget build(BuildContext context) {
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
        _KeypadRow(
          children: [
            displayEraseButton
                ? KeypadItem.action(
                    key: const Key('numpad-action-erase'),
                    icon: Icons.backspace_outlined,
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
                    icon: Icons.check,
                    onTap: () => onProceed?.call(),
                  )
                : const KeypadItem(),
          ],
        ),
      ],
    );
  }
}
