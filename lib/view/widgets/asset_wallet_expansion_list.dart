import 'dart:math';

import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_wallet_item.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';

class AssetWalletExpansionList extends StatelessWidget {
  final List<AssetWallet> assetWallets;

  const AssetWalletExpansionList({
    super.key,
    this.assetWallets = const <AssetWallet>[],
  });

  String getFormattedBalanceSum(final List<NetworkWallet> networkWallets) {
    BigInt sum = BigInt.zero;
    int lowestDecimalPlace = networkWallets
        .map((networkWallet) => networkWallet.decimalPlaces)
        .reduce(min);

    int greatestDecimalPlace = networkWallets
        .map((networkWallet) => networkWallet.decimalPlaces)
        .reduce(max);

    for (final NetworkWallet networkWallet in networkWallets) {
      BigInt compBalance = networkWallet.balance;
      int trailingZeros = 0;

      if (networkWallet.decimalPlaces < greatestDecimalPlace) {
        trailingZeros = greatestDecimalPlace - networkWallet.decimalPlaces;
        compBalance = BigInt.parse(
            '${networkWallet.balance.toString()}${'0' * trailingZeros}');
      }

      sum += compBalance;
    }

    return sum.toDecimalString(
      decimalOffset: greatestDecimalPlace,
      decimalPlaces: lowestDecimalPlace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SioExpansionRadioPanel(
      animationDuration: const Duration(milliseconds: 500),
      dividerColor: Theme.of(context).colorScheme.background,
      children: assetWallets.map(
        (a) {
          final asset = Assets.getAssetDetail(a.assetId);

          return ExpansionPanelRadio(
            value: UniqueKey(),
            backgroundColor: Theme.of(context).colorScheme.background,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.padding10,
                  left: Dimensions.padding16,
                  right: Dimensions.padding16,
                ),
                child: AssetWalletItem(
                  title: asset.name,
                  balance: getFormattedBalanceSum(a.wallets),
                  //TODO.. replace with real price,
                  volume: BigInt.from(123456).getFormattedPrice(
                    locale: Intl.getCurrentLocale(),
                    symbol: '\$',
                  ),
                  backgroundAvatarColor: asset.style.primaryColor,
                  assetType: AssetType.wallet,
                ),
              );
            },
            body: Column(
              children: a.wallets.map((n) {
                final network = Assets.getNetworkDetail(n.networkId);
                return InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .goNamed(AuthenticatedRouter.assetDetail, params: {
                      'assetId': a.assetId.toString(),
                      'networkId': n.networkId.toString(),
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.padding4,
                        left: Dimensions.padding16,
                        right: Dimensions.padding16),
                    child: AssetWalletItem(
                      title: network.name,
                      balance: n.balance.getFormattedBalance(n.decimalPlaces),
                      //TODO.. replace with real price
                      volume: BigInt.from(123456).getFormattedPrice(
                        locale: Intl.getCurrentLocale(),
                        symbol: '\$',
                      ),
                      subTitle: network.ticker,
                      backgroundAvatarColor: asset.style.primaryColor,
                      assetType: AssetType.network,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ).toList(),
    );
  }
}
