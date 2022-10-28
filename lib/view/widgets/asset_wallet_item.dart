import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';

double getHeightByType(AssetType assetType) {
  return assetType == AssetType.wallet ? 70 : 50;
}

double getAvatarSize(AssetType assetType) {
  return assetType == AssetType.wallet ? 40 : 29;
}

class AssetWalletItem extends StatelessWidget {
  const AssetWalletItem({
    required this.title,
    required this.volume,
    required this.balance,
    this.subTitle,
    required this.assetStyle,
    required this.assetType,
    this.onTap,
    super.key,
  });

  final String title;
  final String volume;
  final String balance;
  final String? subTitle;
  final AssetStyle assetStyle;
  final GestureTapCallback? onTap;
  final AssetType assetType;

  TextStyle getTextStyle() {
    return assetType == AssetType.wallet
        ? SioTextStyles.h5
        : SioTextStyles.bodyS;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getHeightByType(assetType),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SioColors.backGradient3Start.withOpacity(0.5),
                SioColors.backGradient3End.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(RadiusSize.radius20)),
        child: Padding(
          padding: Paddings.horizontal16,
          child: Row(children: [
            AvatarWithShadow(
              size: getAvatarSize(assetType),
              child: assetStyle.icon,
            ),
            Gaps.gap10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle().apply(color: SioColors.whiteBlue),
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
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    balance,
                    style:
                        SioTextStyles.bodyS.apply(color: SioColors.whiteBlue),
                  ),
                  Text(
                    volume,
                    style:
                        SioTextStyles.bodyS.apply(color: SioColors.mentolGreen),
                  ),
                ]),
          ]),
        ),
      ),
    );
  }
}

enum AssetType { wallet, network }
