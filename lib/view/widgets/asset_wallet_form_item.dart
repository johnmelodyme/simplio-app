import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

class AssetWalletFormItem extends StatelessWidget {
  final AssetId assetId;
  final NetworkId networkId;
  final BigDecimal cryptoBalance;
  final BigDecimal fiatBalance;
  final String currency;
  final void Function(
    AssetId assetId,
    NetworkId networkId,
  )? onTap;

  const AssetWalletFormItem({
    super.key,
    required this.assetId,
    required this.networkId,
    this.cryptoBalance = const BigDecimal.zero(),
    this.fiatBalance = const BigDecimal.zero(),
    required this.currency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final asset = Assets.getAssetDetail(assetId);

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(
        RadiusSize.radius16,
      ),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: () => onTap?.call(assetId, networkId),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.padding12,
            horizontal: Dimensions.padding16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SioColors.backGradient3Start.withOpacity(0.5),
                SioColors.backGradient3End.withOpacity(0.5),
              ],
            ),
          ),
          child: Row(
            children: [
              AvatarWithShadow(
                size: 30,
                child: asset.style.icon,
              ),
              Expanded(
                child: Padding(
                  padding: Paddings.horizontal10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asset.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: SioTextStyles.bodyS.apply(
                                color: SioColors.whiteBlue,
                              ),
                            ),
                            Text(
                              asset.ticker,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: SioTextStyles.bodyS.apply(
                                color: SioColors.secondary7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CurrencyText(
                            cryptoBalance,
                          ),
                          CurrencyText(
                            fiatBalance,
                            currency: currency,
                            style: SioTextStyles.bodyS.copyWith(
                              color: SioColors.mentolGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
