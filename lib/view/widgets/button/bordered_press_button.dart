import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class BorderedPressButton extends StatelessWidget {
  final VoidCallback onLongPress;
  final bool pressed;
  final String label;
  final IconData? icon;

  const BorderedPressButton({
    super.key,
    required this.onLongPress,
    required this.pressed,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(Constants.buttonHeight),
        backgroundColor:
            pressed ? SioColors.backGradient2 : SioColors.transparent,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadii.radius30,
          side: BorderSide(
            color: SioColors.secondary6,
          ),
        ),
      ),
      onPressed: null,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: SioTextStyles.buttonLarge.apply(
                  color: pressed ? SioColors.secondary6 : SioColors.whiteBlue,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (icon != null) ...[
                Icon(
                  icon!,
                  color: pressed ? SioColors.secondary6 : SioColors.mentolGreen,
                ),
                Gaps.gap10,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
