import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
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
                padding: Paddings.vertical20,
                child: ListTile(
                  leading: asset.style.icon,
                  title: Text(
                    a.name,
                    style: SioTextStyles.h5.apply(color: SioColors.whiteBlue),
                  ),
                ),
              );
            },
            body: Column(
              children: a.networks.map((n) {
                final network = Assets.getNetworkDetail(n.networkId);
                return ListTile(
                  title: Text(network.name,
                      style: SioTextStyles.h5.apply(
                        color: SioColors.whiteBlue,
                      )),
                  subtitle: Text(
                    network.ticker,
                    style:
                        SioTextStyles.bodyS.apply(color: SioColors.secondary7),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: SioColors.whiteBlue,
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
