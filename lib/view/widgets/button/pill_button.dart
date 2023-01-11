import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class PillButton extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final Clip clipBehavior;
  final double borderRadius;
  final VoidCallback? onTap;

  const PillButton(
    this.data, {
    super.key,
    this.style,
    this.clipBehavior = Clip.hardEdge,
    this.borderRadius = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SioColors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: clipBehavior,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.padding4,
            horizontal: Dimensions.padding8,
          ),
          child: Text(
            data,
            style: style ??
                SioTextStyles.bodyS.copyWith(
                  color: SioColors.secondary7,
                ),
          ),
        ),
      ),
    );
  }
}
