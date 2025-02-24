import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/keypad.dart';

class KeypadItem extends StatelessWidget {
  const KeypadItem({
    super.key,
  });

  factory KeypadItem.number({
    key,
    required NumpadValue value,
    required void Function(NumpadValue) onTap,
    bool? isCircular,
    Size? size,
  }) {
    return _KeypadButton<NumpadValue>(
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
    VoidCallback? onLongPress,
    bool? isCircular,
    Size? size,
  }) {
    return _ActionButton(
      key: key,
      content: content,
      actionButtonType: actionType ?? ActionButtonType.flat,
      onTap: onTap,
      onLongPress: onLongPress,
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

class _KeypadButton<T extends NumpadValue> extends KeypadItem {
  final void Function(T value) onTap;
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
        child: Center(
          child: Text(value.value.toString(),
              textAlign: TextAlign.center,
              style: SioTextStyles.numericKeyboard.copyWith(
                color: SioColors.whiteBlue,
                height: 1,
              )),
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
  final VoidCallback? onLongPress;
  final bool isCircular;

  const _ActionButton({
    super.key,
    required this.content,
    required this.size,
    required this.actionButtonType,
    required this.onTap,
    this.onLongPress,
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
        onLongPress: onLongPress,
        customBorder: shape,
        child: Center(
          child: content,
        ),
      ),
    );

    final elevatedBody = SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadii.radius10,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.transparent,
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadii.radius10,
                side: BorderSide.none,
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          child: SizedBox(
            width: Constants.keypadButtonSize.width,
            height: Constants.keypadButtonSize.height,
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SioColorsDark.highlight1,
                    SioColorsDark.vividBlue,
                  ],
                ),
              ),
              child: content,
            ),
          ),
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
