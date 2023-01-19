import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_wallet_item.dart';
import 'package:simplio_app/view/widgets/network_wallet_item.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';

// TODO - rename types
// TODO - impelement filtering privided wallets
typedef ExpansionListFilter = Map<AssetId, Set<NetworkId>>;

class ExpansionListValue<T> {
  final NetworkWallet networkWallet;
  final T value;

  const ExpansionListValue({
    required this.networkWallet,
    required this.value,
  });
}

typedef ExpansionListValues<T>
    = Map<AssetWallet, Iterable<ExpansionListValue<T>>>;

class AssetWalletExpansionList<T> extends StatelessWidget {
  final ValueChanged<T> onTap;
  final ExpansionListValues wallets;

  const AssetWalletExpansionList({
    super.key,
    required this.onTap,
    this.wallets = const {},
  });

  static AssetWalletExpansionList fromAssetWallets({
    Key? key,
    required List<AssetWallet> wallets,
    required ValueChanged<List<int>> onTap,
  }) {
    return AssetWalletExpansionList<List<int>>(
      key: key,
      wallets: wallets.fold({}, (acc, current) {
        return acc
          ..addAll({
            current: current.enabled.map((n) => ExpansionListValue<List<int>>(
                  networkWallet: n,
                  value: [current.assetId, n.networkId],
                ))
          });
      }),
      onTap: onTap,
    );
  }

  // TODO - review and write test
  static AssetWalletExpansionList fromSwapAsset({
    Key? key,
    required Iterable<SwapAsset> assets,
    required AccountWallet accountWallet,
    required ValueChanged<SwapAsset> onTap,
  }) {
    final swapAssets =
        assets.fold<Map<AssetWallet, Set<ExpansionListValue>>>({}, (acc, curr) {
      final aw = accountWallet.getWallet(curr.assetId) ??
          AssetWallet.builder(assetId: curr.assetId);
      final nw = aw.getWallet(curr.networkId) ??
          NetworkWallet.builder(
            assetId: curr.assetId,
            networkId: curr.networkId,
            address: '',
            preset: Assets.getAssetPreset(
              assetId: aw.assetId,
              networkId: curr.networkId,
            ),
          );

      final val = ExpansionListValue(networkWallet: nw, value: curr);
      if (acc.containsKey(aw)) {
        acc[aw]!.add(val);
        return acc;
      }

      acc.addAll({
        aw: {val}
      });

      return acc;
    });

    return AssetWalletExpansionList<SwapAsset>(
      key: key,
      wallets: swapAssets,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SioExpansionRadioPanel(
      animationDuration: const Duration(milliseconds: 500),
      dividerColor: SioColors.softBlack,
      children: wallets
          .map(
            (k, v) {
              final detail = Assets.getAssetDetail(k.assetId);
              return MapEntry(
                k,
                ExpansionPanelRadio(
                  value: UniqueKey(),
                  backgroundColor: SioColors.softBlack,
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: Dimensions.padding10,
                        left: Dimensions.padding16,
                        right: Dimensions.padding16,
                      ),
                      child: AssetWalletItem(
                        wallet: k,
                        assetDetail: detail,
                      ),
                    );
                  },
                  body: Column(
                    children: v.map((n) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.padding4,
                            left: Dimensions.padding16,
                            right: Dimensions.padding16),
                        child: NetworkWalletItem(
                          key: key,
                          assetStyle: detail.style,
                          wallet: n.networkWallet,
                          onTap: () {
                            onTap(n.value);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }
}
