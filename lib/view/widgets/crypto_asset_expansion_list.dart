import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_search_item.dart';
import 'package:simplio_app/view/widgets/network_wallet_search_item.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';

class CryptoAssetExpansionList extends StatelessWidget {
  final List<CryptoAssetData> children;
  final void Function(NetworkData data) onTap;

  const CryptoAssetExpansionList({
    super.key,
    this.children = const <CryptoAssetData>[],
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SioExpansionRadioPanel(
      animationDuration: const Duration(milliseconds: 500),
      children: children.map(
        (a) {
          final asset = Assets.getAssetDetail(a.assetId);

          return ExpansionPanelRadio(
            backgroundColor: SioColors.softBlack,
            value: UniqueKey(),
            canTapOnHeader: true,
            headerBuilder: (context, _) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.padding10,
                  left: Dimensions.padding16,
                  right: Dimensions.padding16,
                ),
                child: AssetSearchItem(
                  label: a.name,
                  priceLabel: '\$12,345.89', //TODO.. replace by real price
                  assetIcon: asset.style.icon,
                  assetAction: const [
                    AssetAction.buy,
                    AssetAction.addToInventory
                  ],
                  onActionPressed: (AssetAction assetAction) {},
                ),
              );
            },
            body: Column(
              children: a.networks.map((n) {
                final network = Assets.getNetworkDetail(n.networkId);
                return Padding(
                  padding: const EdgeInsets.only(
                      top: Dimensions.padding4,
                      left: Dimensions.padding16,
                      right: Dimensions.padding16),
                  child: NetworkWalletSearchItem(
                    title: network.name,
                    subTitle: network.ticker,
                    onTap: () {
                      onTap(n);
                    },
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
