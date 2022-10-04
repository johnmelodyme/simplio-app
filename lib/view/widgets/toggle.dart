import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

class Toggle extends StatefulWidget {
  const Toggle({
    super.key,
    required this.trueOption,
    this.falseOption,
    this.value = false,
    this.onChanged,
  });

  final Widget trueOption;
  final Widget? falseOption;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<StatefulWidget> createState() => _Toggle();
}

class _Toggle extends State<Toggle> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadii.radius64;

    return Container(
      height: Constants.toggleButtonHeight,
      width: widget.falseOption != null
          ? Constants.toggleButtonWidth
          : Constants.singleToggleButtonWidth,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer,
            Theme.of(context).colorScheme.background.withOpacity(0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  widget.onChanged != null ? widget.onChanged!(true) : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: widget.value
                      ? Theme.of(context).colorScheme.outline
                      : null,
                ),
                child: Center(child: widget.trueOption),
              ),
            ),
          ),
          if (widget.falseOption != null)
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    widget.onChanged != null ? widget.onChanged!(false) : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: !widget.value
                        ? Theme.of(context).colorScheme.outline
                        : Colors.transparent,
                  ),
                  child: Center(child: widget.falseOption),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
