import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';

class WelcomeScreenPage extends StatelessWidget {
  const WelcomeScreenPage({
    super.key,
    required this.textSpans,
    required this.subtitle,
    required this.imageRes,
  });

  final List<TextSpan> textSpans;
  final String subtitle;
  final String imageRes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: textSpans,
                  ),
                ),
                Gaps.gap5,
                Text(
                  subtitle,
                  style: SioTextStyles.s1.apply(
                    color: SioColorsDark.secondary7,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Image.asset(
            imageRes,
            fit: BoxFit.fitWidth,
          ),
        )
      ],
    );
  }
}
