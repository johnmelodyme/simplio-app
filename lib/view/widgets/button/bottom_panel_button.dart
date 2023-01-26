import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class BottomPanelButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const BottomPanelButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    final color = isDisabled ? SioColors.secondary6 : SioColors.mentolGreen;

    final content = AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: Paddings.all10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            Text(
              label,
              style: SioTextStyles.buttonSmall.apply(
                color: color,
              ),
            )
          ],
        ),
      ),
    );

    return Material(
      color: SioColors.backGradient4Start,
      borderRadius: BorderRadii.radius15,
      clipBehavior: Clip.hardEdge,
      child: isDisabled
          ? content
          : InkWell(
              onTap: onTap,
              child: content,
            ),
    );
  }
}
