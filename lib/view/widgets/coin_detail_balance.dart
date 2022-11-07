import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/bordered_text_button.dart';
import 'package:simplio_app/view/widgets/earning_elevated_button.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

class CoinDetailBalance extends StatelessWidget {
  const CoinDetailBalance({
    super.key,
    required this.assetDetail,
    required this.networkWallet,
    this.onRemoveFromInventory,
  });

  final AssetDetail assetDetail;
  final NetworkWallet networkWallet;
  final VoidCallback? onRemoveFromInventory;

  bool _isInInventory() {
    return networkWallet.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: Paddings.top30,
          padding: Paddings.all16,
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(RadiusSize.radius20)),
            color: SioColors.secondary1,
          ),
          child: Column(
            children: [
              const Gap(52),
              Text(
                networkWallet.balance
                    .getFormattedBalance(networkWallet.preset.decimalPlaces),
                style: SioTextStyles.h1.apply(color: SioColors.whiteBlue),
              ),
              Text(
                networkWallet.fiatBalance.getThousandValueWithCurrency(
                  locale: Intl.getCurrentLocale(),
                  currency: 'USD', //TODO.. replace by real currency
                ),
                style: SioTextStyles.bodyPrimary
                    .apply(color: SioColors.mentolGreen),
              ),
              Gaps.gap30,
              //todo.. show this earning button by some condition
              const EarningElevatedButton(
                earningType: EarningType.startEarning,
                apyPercentage: 4.75, //TODO.. use real data
              ),
              Gaps.gap10,
              if (networkWallet.balance == BigInt.zero)
                _isInInventory()
                    ? BorderedTextButton(
                        onPressed: () {
                          onRemoveFromInventory?.call();
                          //TODO.. CTA for network wallet removal and refresh state
                        },
                        label: context.locale
                            .coin_detail_screen_remove_from_inventory_button,
                        icon: Icon(
                          SioIcons.cancel_outline,
                          color: SioColors.secondary6,
                        ),
                      )
                    : HighlightedElevatedButton(
                        onPressed: () {
                          //TODO.. CTA for network wallet add and refresh state
                        },
                        label: context
                            .locale.coin_detail_screen_add_to_inventory_button,
                        icon: Icon(
                          SioIcons.plus_rounded,
                          color: SioColors.softBlack,
                        ),
                      ),
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
