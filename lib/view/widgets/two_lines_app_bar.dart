import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:sio_glyphs/sio_icons.dart';

class TwoLinesAppBar extends ColorizedAppBar {
  const TwoLinesAppBar({
    Key? key,
    required String firstPart,
    required String secondPart,
    ActionType? actionType,
    Function()? onBackTap,
  }) : super(
          key: key,
          firstPart: firstPart,
          secondPart: secondPart,
          actionType: actionType ?? ActionType.close,
          onBackTap: onBackTap,
        );

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
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
                      GoRouter.of(context).pop();
                      onBackTap?.call();
                    },
                    padding: const EdgeInsets.all(Dimensions.padding16),
                    color: SioColors.secondary6,
                    icon: actionType == ActionType.back
                        ? const Icon(SioIcons.arrow_left)
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
                            text: '$firstPart\n',
                            style: SioTextStyles.h4
                                .apply(color: SioColors.mentolGreen),
                          ),
                          TextSpan(
                            text: secondPart,
                            style: SioTextStyles.bodyPrimary.apply(
                              color: SioColors.secondary7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
