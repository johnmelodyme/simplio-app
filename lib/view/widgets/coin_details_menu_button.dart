import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

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
      borderRadius: BorderRadiuses.radius15,
      child: Material(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  Text(
                    label,
                    style: SioTextStyles.buttonSmall.apply(
                        color: Theme.of(context).colorScheme.inverseSurface),
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
