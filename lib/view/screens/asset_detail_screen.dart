import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
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

    context
        .read<AccountWalletCubit>()
        .refreshNetworkWalletBalance(networkWallet);

    return Stack(
      children: [
        BackGradient4(
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
                  ),
                ),
              ),
              SliverPadding(
                padding: Paddings.horizontal16,
                sliver: SliverToBoxAdapter(
                  child: CoinDetailBalance(
                    assetDetail: assetDetail,
                    networkWallet: networkWallet,
                    onRemoveFromInventory: () {
                      context.read<AccountWalletCubit>().disableNetworkWallet(
                            assetId: assetWallet.assetId,
                            networkId: networkWallet.networkId,
                          );
                    },
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
                  context.read<AssetBuyFormCubit>().clear();
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.assetBuy,
                    params: {
                      'assetId': assetId!,
                      'networkId': networkId!,
                    },
                  );
                  break;
                case ActionType.exchange:
                  context.read<AssetExchangeFormCubit>().clear();
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.assetExchange,
                    params: {
                      'assetId': assetId!,
                      'networkId': networkId!,
                    },
                  );
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
                  context.read<AssetSendFormCubit>().clear();
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
