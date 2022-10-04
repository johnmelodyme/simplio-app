import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/bordered_elevated_button.dart';
import 'package:simplio_app/view/widgets/earning_elevated_button.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';

class CoinDetailBalance extends StatelessWidget {
  const CoinDetailBalance({
    super.key,
    required this.assetDetail,
    required this.networkWallet,
  });

  final AssetDetail assetDetail;
  final NetworkWallet networkWallet;

  bool _isInInventory() {
    return true;
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
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            children: [
              const Gap(52),
              Text(
                networkWallet.balance
                    .getFormattedBalance(networkWallet.decimalPlaces),
                style: SioTextStyles.h1
                    .apply(color: Theme.of(context).colorScheme.onPrimary),
              ),
              Text(
                networkWallet.balance.getFormattedPrice(
                  locale: Intl.getCurrentLocale(),
                  currency: 'USD', //TODO.. replace by real currency
                ),
                style: SioTextStyles.bodyPrimary
                    .apply(color: Theme.of(context).colorScheme.inverseSurface),
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
                    ? BorderedElevatedButton(
                        onPressed: () {
                          //TODO.. CTA for network wallet removal and refresh state
                        },
                        label: context.locale
                            .coin_detail_screen_remove_from_inventory_button,
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      )
                    : HighlightedElevatedButton(
                        onPressed: () {
                          //TODO.. CTA for network wallet add and refresh state
                        },
                        label: context
                            .locale.coin_detail_screen_add_to_inventory_button,
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.background,
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
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                  spreadRadius: RadiusSize.radius140 / 2,
                  blurRadius: RadiusSize.radius140,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AvatarWithShadow(
                size: 40,
                child: Container(color: assetDetail.style.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
