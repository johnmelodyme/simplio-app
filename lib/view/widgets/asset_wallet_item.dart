import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/helpers/big_decimal.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';

class AssetWalletItem extends StatelessWidget {
  final String currency;
  final String? locale;
  final AssetWallet wallet;
  final AssetDetail? assetDetail;

  const AssetWalletItem({
    super.key,
    required this.wallet,
    this.currency = 'USD',
    this.locale,
    this.assetDetail,
  });

  @override
  Widget build(BuildContext context) {
    final detail = assetDetail ?? Assets.getAssetDetail(wallet.assetId);

    final cryptoAmount = BigDecimal.fromBigInt(BigInt.zero);
    final fiatAmount = BigDecimal.fromBigInt(BigInt.zero);

    return Container(
      height: 70,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            SioColors.backGradient3Start.withOpacity(0.5),
            SioColors.backGradient3End.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(RadiusSize.radius20),
      ),
      child: Padding(
        padding: Paddings.horizontal16,
        child: Row(children: [
          AvatarWithShadow(
            size: 36,
            child: detail.style.icon,
          ),
          Gaps.gap10,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.name,
                  style: SioTextStyles.h5.apply(
                    color: SioColors.whiteBlue,
                  ),
                ),
              ],
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CurrencyText(
                  value: cryptoAmount,
                ),
                CurrencyText(
                  value: fiatAmount,
                  currency: 'USD',
                  style: SioTextStyles.bodyS.copyWith(
                    color: SioColors.mentolGreen,
                  ),
                ),
              ]),
        ]),
      ),
    );
  }
}
