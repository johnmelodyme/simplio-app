import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class ScoreChip extends StatelessWidget {
  const ScoreChip({
    super.key,
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      padding: Paddings.horizontal10,
      decoration: BoxDecoration(
        color: SioColors.softBlack,
        borderRadius: BorderRadii.radius20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$score',
            style: SioTextStyles.bodyLargeBold.copyWith(
              color: SioColors.highlight,
              height: 1,
            ),
          ),
          Gaps.gap5,
          Icon(
            SioIcons.score,
            color: SioColors.highlight,
            size: 14,
          ),
        ],
      ),
    );
  }
}
