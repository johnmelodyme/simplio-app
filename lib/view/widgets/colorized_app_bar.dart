import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/text/highlighted_text.dart';
import 'package:sio_glyphs/sio_icons.dart';

class ColorizedAppBar extends StatelessWidget {
  const ColorizedAppBar({
    Key? key,
    this.actionType = ActionType.back,
    required this.title,
    this.color,
    this.onBackTap,
    this.onShareTap,
  }) : super(key: key);

  final ActionType actionType;
  final String title;
  final Color? color;
  final VoidCallback? onBackTap;
  final VoidCallback? onShareTap;

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
                  if (onBackTap != null) return onBackTap!();
                  GoRouter.of(context).pop();
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
                child: HighlightedText(
                  title,
                  textAlign: TextAlign.center,
                  style: SioTextStyles.h4.apply(
                    color: SioColors.whiteBlue,
                  ),
                  highlightedStyle: SioTextStyles.h4.apply(
                    color: color ?? SioColors.mentolGreen,
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
