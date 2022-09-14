import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';

class AssetWalletItem extends StatelessWidget {
  const AssetWalletItem({
    required this.title,
    required this.volume,
    required this.balance,
    this.subTitle,
    required this.backgroundAvatarColor,
    required this.assetType,
    Key? key,
  }) : super(key: key);

  final String title;
  final String volume;
  final String balance;
  final String? subTitle;
  final Color backgroundAvatarColor;
  final AssetType assetType;

  double getHeightByType() {
    return assetType == AssetType.wallet ? 70 : 50;
  }

  double getAvatarSize() {
    return assetType == AssetType.wallet ? 40 : 29;
  }

  TextStyle getTextStyle() {
    return assetType == AssetType.wallet
        ? SioTextStyles.h5
        : SioTextStyles.bodyS;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeightByType(),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.5),
              Theme.of(context)
                  .colorScheme
                  .onTertiaryContainer
                  .withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(RadiusSize.radius20)),
      child: Padding(
        padding: Paddings.horizontal16,
        child: Row(children: [
          AvatarWithShadov(
            size: getAvatarSize(),
            child: Container(color: backgroundAvatarColor),
          ),
          const Gap(Dimensions.padding10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle()
                      .apply(color: Theme.of(context).colorScheme.onPrimary),
                ),
                if (subTitle?.isNotEmpty == true) ...{
                  Text(
                    subTitle!,
                    style: SioTextStyles.bodyS
                        .apply(color: Theme.of(context).colorScheme.shadow),
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
                  style: SioTextStyles.bodyS
                      .apply(color: Theme.of(context).colorScheme.onPrimary),
                ),
                Text(
                  volume,
                  style: SioTextStyles.bodyS.apply(
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ]),
        ]),
      ),
    );
  }
}

enum AssetType { wallet, network }
