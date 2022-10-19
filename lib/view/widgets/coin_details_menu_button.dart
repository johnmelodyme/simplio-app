import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class CoinDetailsMenuButton extends StatelessWidget {
  const CoinDetailsMenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius15,
      child: Material(
        color: SioColors.backGradient4Start,
        child: InkWell(
          onTap: onPressed.call,
          child: AspectRatio(
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
                    color: SioColors.mentolGreen,
                  ),
                  Text(
                    label,
                    style: SioTextStyles.buttonSmall
                        .apply(color: SioColors.mentolGreen),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
