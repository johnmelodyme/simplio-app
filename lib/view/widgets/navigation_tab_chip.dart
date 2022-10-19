import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class NavigationTabChip extends StatelessWidget {
  const NavigationTabChip({
    Key? key,
    required this.label,
    required this.iconData,
    this.iconColor,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  final String label;
  final IconData? iconData;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SioColors.highlight1,
                    SioColors.vividBlue,
                  ],
                )
              : null,
          color: isSelected ? null : SioColors.backGradient4Start,
          borderRadius: BorderRadii.radius64,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                size: 24,
                color: isSelected
                    ? SioColors.black
                    : iconColor ?? SioColors.whiteBlue,
              ),
              Gaps.gap7,
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                style: SioTextStyles.bodyLargeBold.copyWith(
                  color: isSelected ? SioColors.black : SioColors.whiteBlue,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
