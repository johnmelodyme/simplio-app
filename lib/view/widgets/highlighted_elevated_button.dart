import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class HighlightedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;

  const HighlightedElevatedButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadii.radius30,
        )),
      ),
      onPressed: onPressed,
      child: Ink(
        height: Constants.buttonHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            onPressed != null
                ? SioColors.highlight1
                : SioColors.backGradient4Start,
            onPressed != null ? SioColors.vividBlue : SioColors.blackGradient2,
          ]),
          borderRadius: BorderRadii.radius30,
        ),
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
                color: onPressed != null
                    ? SioColors.softBlack
                    : SioColors.secondary6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
