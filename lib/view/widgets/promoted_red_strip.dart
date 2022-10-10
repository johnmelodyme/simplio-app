import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class PromotedRedStrip extends StatelessWidget {
  const PromotedRedStrip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
          color: SioColors.attention,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(
              RadiusSize.radius10,
            ),
            topRight: Radius.circular(
              RadiusSize.radius10,
            ),
          )),
      child: Padding(
        padding: Paddings.horizontal4,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: SioTextStyles.bodyLargeBold.apply(
            color: SioColors.whiteBlue,
          ),
        ),
      ),
    );
  }
}
