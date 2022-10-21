import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordRulesRow extends StatelessWidget {
  final String text;
  final bool passed;

  const PasswordRulesRow({super.key, required this.text, required this.passed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            passed ? SioIcons.done : SioIcons.cancel,
            size: 16,
            color: passed ? SioColors.mentolGreen : SioColors.attention,
          ),
          Gaps.gap10,
          Text(
            text,
            style: SioTextStyles.bodyDetail.copyWith(
                color: passed ? SioColors.whiteBlue : SioColors.attention,
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize),
          )
        ],
      ),
    );
  }
}
