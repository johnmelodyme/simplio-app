import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';

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
                      onBackTap?.call();
                    },
                    padding: const EdgeInsets.all(Dimensions.padding16),
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    icon: actionType == ActionType.back
                        ? const Icon(Icons.arrow_back_ios)
                        : const Icon(Icons.close),
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
                            style: SioTextStyles.h4.apply(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface),
                          ),
                          TextSpan(
                            text: secondPart,
                            style: SioTextStyles.bodyPrimary.apply(
                              color: Theme.of(context).colorScheme.shadow,
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