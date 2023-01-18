import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class HighlightedElevatedButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  factory HighlightedElevatedButton.primary({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return _PrimaryButton(
      key: key,
      onPressed: onPressed,
      label: label,
      icon: icon,
    );
  }

  factory HighlightedElevatedButton.secondary({
    Key? key,
    required String label,
    IconData? icon,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  }) {
    return _SecondaryButton(
      key: key,
      onPressed: onPressed,
      label: label,
      icon: icon,
      color: SioColors.softBlack,
      textColor: SioColors.mentolGreen,
    );
  }

  factory HighlightedElevatedButton.disabled({
    Key? key,
    required String label,
    IconData? icon,
  }) {
    return _DisabledButton(
      key: key,
      onPressed: null,
      label: label,
      icon: icon,
    );
  }

  const HighlightedElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _PrimaryButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
    );
  }
}

class _PrimaryButton extends HighlightedElevatedButton {
  const _PrimaryButton({
    super.key,
    required super.onPressed,
    required super.label,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _Button(
      label: label,
      icon: icon,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          SioColors.highlight1,
          SioColors.vividBlue,
        ]),
        borderRadius: BorderRadii.radius30,
      ),
      textStyle: SioTextStyles.buttonLarge.apply(
        color: SioColors.softBlack,
      ),
      onPressed: onPressed,
    );
  }
}

class _SecondaryButton extends HighlightedElevatedButton {
  final Color color;
  final Color textColor;

  const _SecondaryButton({
    super.key,
    super.icon,
    required super.onPressed,
    required super.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return _Button(
      label: label,
      icon: icon,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadii.radius30,
      ),
      textStyle: SioTextStyles.buttonLarge.apply(color: textColor),
      onPressed: onPressed,
    );
  }
}

class _DisabledButton extends HighlightedElevatedButton {
  const _DisabledButton({
    super.key,
    super.icon,
    required super.onPressed,
    required super.label,
  });

  @override
  Widget build(BuildContext context) {
    return _Button(
      label: label,
      icon: icon,
      decoration: BoxDecoration(
        color: SioColors.secondary2,
        borderRadius: BorderRadii.radius30,
      ),
      textStyle: SioTextStyles.buttonLarge.apply(
        color: SioColors.secondary4,
      ),
      onPressed: onPressed,
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final BoxDecoration decoration;
  final TextStyle textStyle;

  const _Button({
    required this.onPressed,
    required this.label,
    required this.decoration,
    required this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.zero,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadii.radius30,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        height: Constants.buttonHeight,
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: textStyle.color,
                size: (textStyle.fontSize ?? 16) + 6,
              ),
            Gaps.gap10,
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
