import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class SuccessButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  const SuccessButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadii.radius30,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                SioColors
                    .blackGradient2, // todo: replace with proper color when Theme refactoring is done
                SioColors.backGradient4Start,
              ],
            )),
        child: Padding(
          padding: Paddings.all12,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: SioTextStyles.buttonLarge.apply(
                      color: SioColors.highlight1,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    SioIcons.done,
                    color: SioColors.highlight1,
                    size: 20,
                  ),
                  Gaps.gap6
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
