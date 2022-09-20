import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/coin_detail_balance.dart';
import 'package:simplio_app/view/widgets/coin_details_menu.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/transactions_content.dart';
import 'package:simplio_app/view/widgets/two_lines_app_bar.dart';

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
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.coinsBottomTabBarHeight;

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

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.center,
              colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context).colorScheme.background,
              ],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: FixedHeightItemDelegate(
                  fixedHeight: Constants.appBarHeight +
                      MediaQuery.of(context).viewPadding.top,
                  child: TwoLinesAppBar(
                    firstPart: networkDetail.name,
                    secondPart: networkDetail.ticker,
                    onBackTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              SliverPadding(
                padding: Paddings.horizontal16,
                sliver: SliverToBoxAdapter(
                  child: CoinDetailBalance(
                    assetDetail: assetDetail,
                    networkWallet: networkWallet,
                  ),
                ),
              ),
              const SliverGap(Dimensions.padding16),
              const TransactionsContent(),
              SliverGap(bottomGap)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CoinDetailsMenu(
            onActionCallback: (actionType) {
              switch (actionType) {
                case ActionType.buy:
                  // TODO: Handle this case.
                  break;
                case ActionType.exchange:
                  // TODO: Handle this case.
                  break;
                case ActionType.receive:
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.assetReceive,
                    params: {
                      'assetId': assetId!,
                      'networkId': networkId!,
                    },
                  );
                  break;
                case ActionType.send:
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.assetSend,
                    params: {
                      'assetId': assetId!,
                      'networkId': networkId!,
                    },
                  );
                  break;
                case ActionType.earn:
                  // TODO: Handle this case.
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}
