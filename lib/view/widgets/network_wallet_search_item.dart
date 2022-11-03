import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_search_item.dart';
import 'package:sio_glyphs/sio_icons.dart';

class NetworkWalletSearchItem extends StatelessWidget {
  const NetworkWalletSearchItem({
    required this.title,
    required this.selectedAssetAction,
    required this.icon,
    this.subTitle,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final String title;
  final String? subTitle;
  final GestureTapCallback? onTap;
  final AssetAction selectedAssetAction;

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
            icon,
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
            selectedAssetAction == AssetAction.addToInventory
                ? IconButton(
                    icon: Icon(
                      SioIcons.plus_rounded,
                      color: SioColors.mentolGreen,
                    ),
                    onPressed: () => onTap?.call(),
                  )
                : IconButton(
                    icon: Icon(
                      SioIcons.basket,
                      color: SioColors.coins,
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
