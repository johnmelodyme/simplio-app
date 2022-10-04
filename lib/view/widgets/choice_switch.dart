import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

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
    final borderRadius = BorderRadii.radius64;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer,
            SioColors
                .blackGradient2, // todo: replace with proper color when Theme refactoring is done
          ],
        ),
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
                      padding: Paddings.vertical12,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.value.text.data ?? '',
                              style: TextStyle(
                                color: widget.value == e.key
                                    ? Theme.of(context).colorScheme.background
                                    : Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Gaps.gap8,
                            Icon(
                              e.value.icon.icon,
                              color: widget.value == e.key
                                  ? Theme.of(context).colorScheme.background
                                  : e.value.defaultIconColor ??
                                      Theme.of(context).colorScheme.onPrimary,
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
