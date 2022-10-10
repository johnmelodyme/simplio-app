import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SlidableBannerIndicator extends StatelessWidget {
  const SlidableBannerIndicator({
    super.key,
    required this.pagesCount,
    required this.currentPage,
  });

  final int pagesCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(pagesCount, (index) {
        return Container(
          margin: Paddings.horizontal5,
          width: Constants.slidableBannerBulletSize,
          height: Constants.slidableBannerBulletSize,
          decoration: BoxDecoration(
            color: currentPage == index
                ? SioColors.whiteBlue
                : SioColors.secondary1,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
