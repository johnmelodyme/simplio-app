import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/common_theme.dart';

class AssetWalletExpansionList extends StatelessWidget {
  final List<AssetWallet> children;

  const AssetWalletExpansionList({
    super.key,
    this.children = const <AssetWallet>[],
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      elevation: 0,
      children: children.map(
        (a) {
          final asset = Assets.getAssetDetail(a.assetId);
          return ExpansionPanelRadio(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            value: UniqueKey(),
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return Padding(
                padding: CommonTheme.verticalPadding,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: asset.style.primaryColor,
                  ),
                  title: Text(asset.name),
                ),
              );
            },
            body: Column(
              children: a.wallets.map((n) {
                final network = Assets.getNetworkDetail(n.networkId);
                return ListTile(
                  title: Text(network.name),
                  subtitle: Text(network.ticker),
                  onTap: () => GoRouter.of(context).goNamed(
                    AuthenticatedRouter.assetReceive,
                    params: {
                      'assetId': a.assetId.toString(),
                      'networkId': n.networkId.toString(),
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
