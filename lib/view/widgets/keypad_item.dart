import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class KeypadItem extends StatelessWidget {
  const KeypadItem({
    super.key,
  });

  factory KeypadItem.number({
    key,
    required int value,
    required Function(int) onTap,
    bool? isCircular,
    Size? size,
  }) {
    return _KeypadButton<int>(
      key: key,
      value: value,
      onTap: onTap,
      isCircular: isCircular ?? true,
      size: size ?? Constants.keypadButtonSize,
    );
  }

  factory KeypadItem.decimal({
    key,
    required VoidCallback onTap,
    required BuildContext context,
    bool? isCircular,
    Size? size,
  }) {
    return _ActionButton(
      key: key,
      content: Text(
        '.',
        style:
            SioTextStyles.numericKeyboard.copyWith(color: SioColors.whiteBlue),
      ),
      actionButtonType: ActionButtonType.flat,
      onTap: onTap,
      isCircular: isCircular ?? true,
      size: size ?? Constants.keypadButtonSize,
    );
  }

  factory KeypadItem.action({
    key,
    required Widget content,
    ActionButtonType? actionType,
    required VoidCallback onTap,
    bool? isCircular,
    Size? size,
  }) {
    return _ActionButton(
      key: key,
      content: content,
      actionButtonType: actionType ?? ActionButtonType.flat,
      onTap: onTap,
      isCircular: isCircular ?? true,
      size: size ?? Constants.keypadButtonSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Constants.keypadButtonSize.width,
      height: Constants.keypadButtonSize.height,
    );
  }
}

class _KeypadButton<T> extends KeypadItem {
  final Function(T) onTap;
  final T value;
  final Size size;
  final bool isCircular;

  const _KeypadButton({
    super.key,
    required this.value,
    required this.onTap,
    required this.size,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: InkWell(
        key: key,
        onTap: () => onTap(value),
        customBorder: isCircular ? const CircleBorder() : null,
        child: Container(
          alignment: Alignment.center,
          child: Text(value.toString(),
              style: SioTextStyles.numericKeyboard
                  .copyWith(color: SioColors.whiteBlue)),
        ),
      ),
    );
  }
}

enum ActionButtonType {
  flat,
  elevated,
}

class _ActionButton extends KeypadItem {
  final Widget content;
  final Size size;
  final ActionButtonType actionButtonType;
  final VoidCallback onTap;
  final bool isCircular;

  const _ActionButton({
    super.key,
    required this.content,
    required this.size,
    required this.actionButtonType,
    required this.onTap,
    required this.isCircular,
  });

  @override
  Widget build(BuildContext context) {
    final CircleBorder? shape = isCircular ? const CircleBorder() : null;

    final Widget flatBody = SizedBox(
      width: size.width,
      height: size.height,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Center(
          child: content,
        ),
      ),
    );

    final elevatedBody = SizedBox(
      width: size.width,
      height: size.height,
      child: ElevatedButton(
        onPressed: onTap,
        child: Center(
          child: content,
        ),
      ),
    );

    switch (actionButtonType) {
      case ActionButtonType.flat:
        return flatBody;
      case ActionButtonType.elevated:
        return elevatedBody;
      default:
        return flatBody;
    }
  }
}
