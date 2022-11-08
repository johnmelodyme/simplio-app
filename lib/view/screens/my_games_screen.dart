import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/app_bar_mask.dart';
import 'package:simplio_app/view/widgets/avatar_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/my_games_content.dart';
import 'package:simplio_app/view/widgets/screen_with_dialog.dart';
import 'package:simplio_app/view/widgets/search_bar_placeholder.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyGamesScreen extends ScreenWithDialog {
  MyGamesScreen({super.key})
      : super(
          panelController: PanelController(),
        );

  @override
  Widget innerBuild(BuildContext context) {
    final scrollController = ScrollController();
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.bottomTabBarHeight;

    final topGap = MediaQuery.of(context).viewPadding.top;

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
                  SliverPadding(
                    padding: Paddings.horizontal16,
                    sliver: SliverPersistentHeader(
                      floating: true,
                      delegate: FixedHeightItemDelegate(
                        fixedHeight: Constants.searchBarHeight,
                        child: SearchBarPlaceholder(
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                              AuthenticatedRouter.gamesSearch,
                            );
                          },
                          label: context
                              .locale.discovery_screen_search_and_add_games,
                        ),
                      ),
                    ),
                  ),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: SizedBox(height: topGap + Constants.appBarHeight),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBarMask(
                height: topGap + Constants.appBarHeight + Dimensions.padding20,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: AvatarAppBar(
                title: 'Nick name',
                userLevel: 1,
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.configuration,
                  );
                },
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
