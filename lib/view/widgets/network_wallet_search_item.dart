import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class NetworkWalletSearchItem extends StatelessWidget {
  const NetworkWalletSearchItem({
    required this.title,
    this.subTitle,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subTitle;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SioColors.backGradient3Start.withOpacity(0.5),
                SioColors.backGradient3End.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(RadiusSize.radius16)),
        child: Padding(
          padding: Paddings.horizontal16,
          child: Row(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        SioTextStyles.bodyS.apply(color: SioColors.whiteBlue),
                  ),
                  if (subTitle?.isNotEmpty == true) ...{
                    Text(
                      subTitle!,
                      style: SioTextStyles.bodyS
                          .apply(color: SioColors.secondary7),
                    ),
                  }
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                SioIcons.plus_rounded,
                color: SioColors.mentolGreen,
              ),
              onPressed: () => onTap?.call(),
            )
          ]),
        ),
      ),
    );
  }
}

enum AssetType { wallet, network }
