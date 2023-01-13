import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class BorderedTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const BorderedTextButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.labelColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return _BorderedTextButton(
      key: key,
      onPressed: onPressed,
      label: label,
      icon: icon,
      labelColor: labelColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    );
  }
}

class _BorderedTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const _BorderedTextButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.labelColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(Constants.buttonHeight),
        backgroundColor: SioColors.transparent,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadii.radius30,
          side: BorderSide(
            color: borderColor ?? SioColors.secondary6,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            Gaps.gap10,
          ],
          Text(
            label,
            style: SioTextStyles.buttonLarge.apply(
              color: labelColor ?? SioColors.secondary6,
            ),
          ),
        ],
      ),
    );
  }
}
