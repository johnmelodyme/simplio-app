import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class ValueSwitch<T> extends StatelessWidget {
  final List<ValueSwitchOption<T>> options;
  final T value;
  final Function(T value)? onSwitch;

  const ValueSwitch({
    super.key,
    required this.options,
    required this.value,
    this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          color: SioColors.softBlack,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
        color: SioColors.secondary2,
      ),
      child: Row(
        children: options
            .map((o) => GestureDetector(
                  onTap: () => o.isDisabled ? null : onSwitch?.call(o.value),
                  child: o.isDisabled
                      ? _SwitchDisabledItem(
                          key: o.key,
                          label: o.label,
                        )
                      : _SwitchItem(
                          key: o.key,
                          label: o.label,
                          isActive: o.value == value,
                        ),
                ))
            .toList(),
      ),
    );
  }
}

class _SwitchItem extends StatelessWidget {
  final String label;
  final bool isActive;

  const _SwitchItem({
    super.key,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isActive ? SioColors.mentolGreen : Colors.transparent,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: SioTextStyles.bodyS.copyWith(
          color: isActive ? SioColors.softBlack : SioColors.whiteBlue,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _SwitchDisabledItem extends StatelessWidget {
  final String label;

  const _SwitchDisabledItem({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: SioTextStyles.bodyS.copyWith(
          color: SioColors.secondary7,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ValueSwitchOption<T> {
  final Key? key;
  final T value;
  final String label;
  final bool isDisabled;

  const ValueSwitchOption({
    this.key,
    required this.value,
    required this.label,
    this.isDisabled = false,
  });
}
