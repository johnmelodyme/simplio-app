import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/widgets/body_text.dart';

// todo: dummy page which will be redesigned later together with unlocalized strings
class AssetDetailScreen extends StatelessWidget with WalletUtilsMixin {
  final String? assetId;
  final String? networkId;

  const AssetDetailScreen({
    super.key,
    required this.assetId,
    required this.networkId,
  });

  @override
  Widget build(BuildContext context) {
    final AssetWallet? assetWallet = getAssetWallet(context, assetId!);
    final NetworkWallet? networkWallet =
        getNetwork(context, assetId!, networkId!);

    if (assetWallet == null) {
      throw Exception('No AssetWallet Provided');
    }

    if (networkWallet == null) {
      throw Exception('No Network Provided');
    }

    final assetDetail = Assets.getAssetDetail(assetWallet.assetId);
    final networkDetail = Assets.getNetworkDetail(networkWallet.networkId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // todo: do not forget to replace this with correct localized string
                BodyText('${assetDetail.name} on ${networkDetail.name} network')
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              GoRouter.of(context).pushNamed(
                AuthenticatedRouter.assetSend,
                params: {
                  'assetId': assetId!,
                  'networkId': networkId!,
                },
              );
              break;
            case 1:
              GoRouter.of(context).pushNamed(
                AuthenticatedRouter.assetReceive,
                params: {
                  'assetId': assetId!,
                  'networkId': networkId!,
                },
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.send),
            label: context.locale.asset_send_screen_send_coins_btn,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.get_app),
            label: context.locale.asset_receive_screen_receive_coins_btn,
          ),
        ],
      ),
    );
  }
}
