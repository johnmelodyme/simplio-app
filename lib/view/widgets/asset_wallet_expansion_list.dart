import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_wallet_item.dart';
import 'package:simplio_app/view/widgets/sio_expansion_panel.dart' as sio_panel;

class AssetWalletExpansionList extends StatelessWidget {
  final List<AssetWallet> children;

  const AssetWalletExpansionList({
    super.key,
    this.children = const <AssetWallet>[],
  });

  @override
  Widget build(BuildContext context) {
    return sio_panel.ExpansionPanelList.radio(
      elevation: 0,
      dividerColor: Theme.of(context).colorScheme.background,
      expandedHeaderPadding: EdgeInsets.zero,
      children: children.map(
        (a) {
          final asset = Assets.getAssetDetail(a.assetId);

          return sio_panel.ExpansionPanelRadio(
            backgroundColor: Theme.of(context).colorScheme.background,
            value: UniqueKey(),
            canTapOnHeader: true,
            hasIcon: false,
            hasVerticalExpandedGap: false,
            headerBuilder: (context, isExpanded) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.padding10,
                  left: Dimensions.padding16,
                  right: Dimensions.padding16,
                ),
                child: AssetWalletItem(
                  title: asset.name,
                  price: '220.8',
                  volume: '\$24.70',
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
                        .goNamed(AuthenticatedRouter.assetReceive, params: {
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
                      price: '220.8',
                      volume: '\$24.70',
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
