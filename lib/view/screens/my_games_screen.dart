import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/my_games_content.dart';
import 'package:simplio_app/view/widgets/screen_with_dialog.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class MyGamesScreen extends ScreenWithDialog {
  const MyGamesScreen({super.key})
      : super(
          withBottomTabBar: true,
        );

  @override
  Widget innerBuild(BuildContext context) {
    final scrollController = ScrollController();
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.bottomTabBarHeight;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SioScaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                slivers: [
                  SliverGap(MediaQuery.of(context).viewPadding.top +
                      Constants.appBarHeight),
                  const SliverGap(Dimensions.padding20),
                  MyGamesContent(
                    onCoinAdd: (int assetId, int networkId) {
                      context.read<DialogCubit>().showDialog(
                        (proceed) async {
                          if (proceed) {
                            await context
                                .read<AccountWalletCubit>()
                                .enableNetworkWallet(
                                  assetId: assetId,
                                  networkId: networkId,
                                )
                                .then((_) {
                              _buyCoin(context, assetId, networkId);
                            });
                          }
                        },
                        DialogType.createCoin,
                      );
                    },
                  ),
                  SliverGap(bottomGap)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buyCoin(BuildContext context, int assetId, int networkId) {
    context.read<AssetBuyFormCubit>().clear();
    GoRouter.of(context).pushNamed(AuthenticatedRouter.assetBuy, params: {
      'assetId': '$assetId',
      'networkId': '$networkId',
    });
  }
}
