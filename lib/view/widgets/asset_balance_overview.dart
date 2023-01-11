import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/model/helpers/big_decimal.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';

class AssetBalanceOverview extends StatelessWidget {
  final AssetDetail assetDetail;
  final NetworkWallet networkWallet;
  final String currency;
  final List<Widget> children;

  const AssetBalanceOverview({
    super.key,
    required this.assetDetail,
    required this.networkWallet,
    this.currency = 'USD',
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: Paddings.top30,
          padding: Paddings.all16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: SioColors.secondary1,
            borderRadius: const BorderRadius.all(
              Radius.circular(RadiusSize.radius20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: Paddings.vertical32,
                child: Column(
                  children: [
                    CurrencyText(
                      value: BigDecimal.fromBigInt(networkWallet.balance),
                      style: SioTextStyles.h1.apply(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                    CurrencyText(
                      value: BigDecimal.fromDouble(networkWallet.fiatBalance),
                      currency: currency,
                      style: SioTextStyles.bodyPrimary.apply(
                        color: SioColors.mentolGreen,
                      ),
                    ),
                  ],
                ),
              ),
              ...children,
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.circular(RadiusSize.radius50)),
              color: SioColors.softBlack,
              boxShadow: [
                BoxShadow(
                  color: SioColors.vividBlue.withOpacity(0.1),
                  spreadRadius: RadiusSize.radius140 / 2,
                  blurRadius: RadiusSize.radius140,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: AvatarWithShadow(
                size: 40,
                child: assetDetail.style.icon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
