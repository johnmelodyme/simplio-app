import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

// todo: change colors after proper color pallet is defined
class Toggle extends StatefulWidget {
  const Toggle({
    super.key,
    required this.trueOption,
    required this.falseOption,
    required this.value,
    required this.onChanged,
  });

  final Widget trueOption;
  final Widget falseOption;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<StatefulWidget> createState() => _Toggle();
}

class _Toggle extends State<Toggle> {
  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadiuses.radius64;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onChanged(true),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: widget.value
                      ? Theme.of(context).colorScheme.surfaceTint
                      : Colors.transparent,
                ),
                child: Center(child: widget.trueOption),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: !widget.value
                      ? Theme.of(context).colorScheme.surfaceTint
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
