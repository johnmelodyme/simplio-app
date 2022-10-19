import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class ColorizedAppBar extends StatelessWidget {
  const ColorizedAppBar({
    Key? key,
    required this.firstPart,
    required this.secondPart,
    this.actionType = ActionType.back,
    this.onBackTap,
    this.onShareTap,
  }) : super(key: key);

  final String firstPart;
  final String secondPart;
  final ActionType actionType;
  final Function()? onBackTap;
  final Function()? onShareTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top,
      ),
      child: SizedBox(
        height: Constants.appBarHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onBackTap?.call();
                },
                padding: const EdgeInsets.all(Dimensions.padding16),
                color: SioColors.secondary6,
                icon: actionType == ActionType.back
                    ? const Icon(SioIcons.arrow_left, size: 20)
                    : const Icon(SioIcons.cancel, size: 20),
              ),
            ),
            Positioned.fill(
              left: Dimensions.padding48,
              right: Dimensions.padding48,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$firstPart ',
                        style: SioTextStyles.h4.apply(
                          color: SioColors.whiteBlue,
                        ),
                      ),
                      TextSpan(
                        text: secondPart,
                        style: SioTextStyles.h4
                            .apply(color: SioColors.mentolGreen),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (onShareTap != null)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    onShareTap?.call();
                  },
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  color: SioColors.secondary6,
                  icon: const Icon(SioIcons.share),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum ActionType { back, close }
