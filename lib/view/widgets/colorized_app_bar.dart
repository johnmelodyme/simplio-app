import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class ColorizedAppBar extends StatelessWidget {
  const ColorizedAppBar({
    Key? key,
    required this.firstPart,
    required this.secondPart,
    this.actionType = ActionType.back,
    this.onBackTap,
  }) : super(key: key);

  final String firstPart;
  final String secondPart;
  final ActionType actionType;
  final Function()? onBackTap;

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
                  onBackTap?.call();
                },
                padding: const EdgeInsets.all(Dimensions.padding16),
                color: Colors.white,
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
                        text: '$firstPart ',
                        style: SioTextStyles.h4.apply(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      TextSpan(
                        text: secondPart,
                        style: SioTextStyles.h4.apply(
                            color:
                                Theme.of(context).colorScheme.inverseSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}

enum ActionType { back, close }
