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
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            top: Dimensions.padding16 +
                Dimensions.padding46 +
                Constants.storyIndicatorHeight,
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
            bottom: _bottomMargin(context),
            child: Image.asset(
              imageRes,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }

  double _bottomMargin(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 700) return -30;
    if (screenHeight > 900) return 30;
    return 0;
  }
}
