import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class TextHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const TextHeader({
    super.key,
    this.title = '',
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  title,
                  style: SioTextStyles.h1.apply(
                    color: SioColors.whiteBlue,
                  ),
                ),
              ),
            if (subtitle.isNotEmpty)
              Text(subtitle,
                  style: SioTextStyles.bodyPrimary.apply(
                    color: SioColors.whiteBlue,
                  )),
          ],
        ),
      ],
    );
  }
}
