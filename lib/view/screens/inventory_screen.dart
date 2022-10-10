import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/inventory_coins_content.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/search_bar_placeholder.dart';
import 'package:simplio_app/view/widgets/total_balance.dart';
import 'package:simplio_app/view/widgets/transactions_content.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
    this.inventoryTab = InventoryTab.coins,
  });

  final InventoryTab inventoryTab;

  @override
  Widget build(BuildContext context) {
    context
        .read<AccountWalletCubit>()
        .refreshAccountWalletBalance(forceUpdate: true);

    return BlocBuilder<AccountWalletCubit, AccountWalletState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return NavigationTabBar(
          tabs: [
            NavigationBarTabItem(
                label: context.locale.inventory_tab_coins,
                searchBar: SearchBarPlaceholder(
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                      AuthenticatedRouter.assetSearch,
                    );
                  },
                  label: context.locale.inventory_screen_search_and_add_coins,
                ),
                iconData: Icons.pie_chart_outline,
                iconColor: SioColors.coins,
                topSlivers: [
                  const SliverGap(Dimensions.padding16),
                  //todo.. replace by real data
                  const TotalBalance(balance: 2402.7),
                  const SliverGap(Dimensions.padding20),
                ],
                bottomSlivers: [
                  const SliverGap(Dimensions.padding10),
                  const InventoryCoinsContent(),
                  const SliverGap(Dimensions.padding20),
                ]),
            NavigationBarTabItem(
                label: context.locale.inventory_tab_nft,
                searchBar: SearchBarPlaceholder(
                  label: context.locale.inventory_screen_search_nft,
                ),
                iconData: Icons.pie_chart_outline,
                iconColor: SioColors.nft,
                topSlivers: [
                  const SliverGap(Dimensions.padding16),
                  //todo.. replace by real data
                  const TotalBalance(balance: 2402.7),
                  const SliverGap(Dimensions.padding20),
                ],
                bottomSlivers: [
                  const SliverGap(100)
                ]),
            NavigationBarTabItem(
                label: context.locale.inventory_tab_transactions,
                searchBar: SearchBarPlaceholder(
                  label: context.locale.inventory_screen_search_transactions,
                ),
                topSlivers: [
                  const SliverGap(Dimensions.padding16),
                  //todo.. replace by real data
                  const TotalBalance(balance: 2402.7),
                  const SliverGap(Dimensions.padding20),
                ],
                bottomSlivers: [
                  const SliverGap(Dimensions.padding20),
                  const TransactionsContent(),
                ])
          ],
        );
      },
    );
  }
}

enum InventoryTab { coins, nft, transactions }
