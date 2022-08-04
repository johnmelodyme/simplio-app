import 'package:flutter/material.dart';

const _keypadButtonDefaultSize = Size(60.0, 60.0);

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

  factory KeypadItem.action({
    key,
    String? label,
    IconData? icon,
    ActionButtonType? actionType,
    required VoidCallback onTap,
    bool? isCircular,
    Size? size,
  }) {
    return _ActionButton(
      key: key,
      label: label ?? 'Action',
      icon: icon,
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
  final String label;
  final IconData? icon;
  final Size size;
  final ActionButtonType actionButtonType;
  final VoidCallback onTap;
  final bool isCircular;

  const _ActionButton({
    super.key,
    required this.label,
    this.icon,
    required this.size,
    required this.actionButtonType,
    required this.onTap,
    required this.isCircular,
  });

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final Widget child = icon != null
        ? Icon(icon, color: th.textTheme.titleMedium?.color)
        : Text(label);

    final CircleBorder? shape = isCircular ? const CircleBorder() : null;

    final Widget flatBody = SizedBox(
      width: size.width,
      height: size.height,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Center(
          child: child,
        ),
      ),
    );

    final elevatedBody = SizedBox(
      width: size.width,
      height: size.height,
      child: ElevatedButton(
        onPressed: onTap,
        child: Center(
          child: child,
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
