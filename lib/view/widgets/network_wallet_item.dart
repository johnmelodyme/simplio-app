import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

class NetworkWalletItem extends StatelessWidget {
  final NetworkWallet wallet;
  final AssetStyle? assetStyle;
  final VoidCallback? onTap;

  const NetworkWalletItem({
    super.key,
    required this.wallet,
    this.assetStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO - The icon might be the icon of an asset wallet.
    final detail = Assets.getNetworkDetail(wallet.networkId);
    final icon = assetStyle?.icon ?? detail.style.icon;

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
          borderRadius: BorderRadius.circular(
            RadiusSize.radius16,
          ),
        ),
        child: Padding(
          padding: Paddings.horizontal16,
          child: Row(children: [
            AvatarWithShadow(
              size: 28,
              child: icon,
            ),
            Gaps.gap10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // TODO - test long text
                    detail.name,
                    style: SioTextStyles.bodyS.apply(
                      color: SioColors.whiteBlue,
                    ),
                  ),
                  Text(
                    detail.ticker,
                    style: SioTextStyles.bodyS.apply(
                      color: SioColors.secondary7,
                    ),
                  ),
                ],
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TODO - replace with real balance
                  const CurrencyText(
                    value: BigDecimal.zero(),
                  ),
                  CurrencyText(
                    value: const BigDecimal.zero(),
                    currency: 'USD',
                    style: SioTextStyles.bodyS.copyWith(
                      color: SioColors.mentolGreen,
                    ),
                  ),
                ]),
          ]),
        ),
      ),
    );
  }
}
