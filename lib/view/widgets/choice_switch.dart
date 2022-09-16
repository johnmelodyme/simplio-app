import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';

class SwitchWidget {
  const SwitchWidget({
    required this.gradient,
    required this.text,
    required this.icon,
    this.defaultIconColor,
  });

  final Gradient gradient;
  final Text text;
  final Icon icon;
  final Color? defaultIconColor;
}

// todo: change colors after proper color pallet is defined
class ChoiceSwitch extends StatefulWidget {
  const ChoiceSwitch({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<SwitchWidget> options;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<StatefulWidget> createState() => _Switch();
}

class _Switch extends State<ChoiceSwitch> {
  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadiuses.radius64;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.options
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                child: GestureDetector(
                  onTap: () => widget.onChanged(e.key),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: widget.value == e.key ? e.value.gradient : null,
                    ),
                    child: Padding(
                      padding: Paddings.vertical10,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.value.text.data ?? '',
                              style: TextStyle(
                                color: widget.value == e.key
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const Gap(Dimensions.padding8),
                            Icon(
                              e.value.icon.icon,
                              color: widget.value == e.key
                                  ? Colors.black
                                  : e.value.defaultIconColor ?? Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
