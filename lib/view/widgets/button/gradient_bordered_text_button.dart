import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/outlined_container.dart';

class GradientBorderedTextButton extends StatelessWidget {
  const GradientBorderedTextButton({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius30,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap?.call(),
          child: SizedBox(
            height: Constants.earningButtonHeight,
            child: OutlinedContainer(
              strokeWidth: 1,
              radius: RadiusSize.radius30,
              gradient: LinearGradient(
                colors: [
                  SioColors.highlight1,
                  SioColors.vividBlue,
                ],
              ),
              child: Padding(
                padding: Paddings.horizontal20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: SioTextStyles.buttonLarge.copyWith(
                        color: SioColors.whiteBlue,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
