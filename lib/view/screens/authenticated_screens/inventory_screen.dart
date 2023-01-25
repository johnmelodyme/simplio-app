import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/routers/authenticated_routes/discovery_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/discovery_screen.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/inventory_coins_content.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/no_content_placeholder.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/total_balance_overview.dart';
import 'package:simplio_app/view/widgets/transactions_content.dart';
import 'package:sio_glyphs/sio_icons.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
    this.tab = InventoryTab.coins,
  });

  final InventoryTab tab;

  @override
  Widget build(BuildContext context) {
    // TODO - refactor fetching balance.
    // context
    //     .read<AccountWalletCubit>()
    //     .refreshAccountWalletBalance(forceUpdate: true);

    return SioScaffold(
      body: BlocBuilder<AccountWalletCubit, AccountWalletState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is! AccountWalletProvided) {
            return const SizedBox.shrink();
          }

          return NavigationTabBar(
            currentTab: tab.index,
            tabs: [
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_coins,
                  iconData: SioIcons.coins,
                  iconColor: SioColors.coins,
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    TotalBalanceOverview(balance: state.wallet.fiatBalance),
                    const SliverGap(Dimensions.padding20),
                  ],
                  bottomSlivers: [
                    const SliverGap(Dimensions.padding10),
                    const InventoryCoinsContent(),
                    const SliverGap(Dimensions.padding20),
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_nft,
                  iconData: SioIcons.nft,
                  iconColor: SioColors.nft,
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    TotalBalanceOverview(balance: state.wallet.fiatBalance),
                    const SliverGap(Dimensions.padding20),
                  ],
                  bottomSlivers: [
                    const SliverGap(100),
                    NoContentPlaceholder(
                      title:
                          context.locale.inventory_screen_nft_empty_list_label,
                      buttonLabel:
                          context.locale.inventory_screen_discover_new_nft,
                      onPressed: () {
                        GoRouter.of(context).goNamed(
                          DiscoveryRoute.name,
                          extra: DiscoveryTab.nft,
                        );
                      },
                    ),
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_transactions,
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    TotalBalanceOverview(balance: state.wallet.fiatBalance),
                    const SliverGap(Dimensions.padding20),
                  ],
                  bottomSlivers: [
                    const SliverGap(Dimensions.padding20),
                    const TransactionsContent(),
                  ])
            ],
          );
        },
      ),
    );
  }
}

enum InventoryTab { coins, nft, transactions }
