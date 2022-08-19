import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_colors.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class NavigationTabChip extends StatelessWidget {
  const NavigationTabChip({
    Key? key,
    this.label = '',
    this.iconData,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final String label;
  final IconData? iconData;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RadiusSize.radius64))),
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: isSelected
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SColors.tabStartColor,
                    SColors.tabEndColor,
                  ],
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(RadiusSize.radius64)),
              )
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null) ...{
              Icon(
                iconData,
                size: 16,
                color: isSelected ? SColors.black : SColors.white,
              ),
              const Gap(PaddingSize.padding8),
            },
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                style: STextStyles.bodyM
                    .apply(color: isSelected ? SColors.black : SColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
