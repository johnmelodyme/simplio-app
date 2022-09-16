import 'package:flutter/material.dart';

const _keypadButtonDefaultSize = Size(100.0, 60.0);

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
      size: size ?? _keypadButtonDefaultSize,
    );
  }

  factory KeypadItem.decimal({
    key,
    required VoidCallback onTap,
    bool? isCircular,
    Size? size,
  }) {
    return _ActionButton(
      key: key,
      content: const Text('.', style: TextStyle(fontSize: 32)),
      actionButtonType: ActionButtonType.flat,
      onTap: onTap,
      isCircular: isCircular ?? true,
      size: size ?? _keypadButtonDefaultSize,
    );
  }

  factory KeypadItem.action({
    key,
    required Icon content,
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
      size: size ?? _keypadButtonDefaultSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _keypadButtonDefaultSize.width,
      height: _keypadButtonDefaultSize.height,
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
    final th = Theme.of(context).textTheme.headlineMedium;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: InkWell(
        key: key,
        onTap: () => onTap(value),
        customBorder: isCircular ? const CircleBorder() : null,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: th?.fontSize,
              fontWeight: th?.fontWeight,
            ),
          ),
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
