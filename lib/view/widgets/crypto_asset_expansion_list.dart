import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';

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
    return ExpansionPanelList.radio(
      elevation: 0,
      children: children.map(
        (a) {
          final asset = Assets.getAssetDetail(a.assetId);

          return ExpansionPanelRadio(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            value: UniqueKey(),
            canTapOnHeader: true,
            headerBuilder: (context, _) {
              return Padding(
                padding: Paddings.vertical20,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: asset.style.primaryColor,
                  ),
                  title: Text(a.name),
                ),
              );
            },
            body: Column(
              children: a.networks.map((n) {
                final network = Assets.getNetworkDetail(n.networkId);
                return ListTile(
                  title: Text(network.name),
                  subtitle: Text(network.ticker),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => onTap(n),
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
