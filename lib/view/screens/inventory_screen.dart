import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_search_delegate.dart';
import 'package:simplio_app/view/widgets/inventory_coins_content.dart';
import 'package:simplio_app/view/widgets/navigation_bar_tab_item.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/search_bar.dart';
import 'package:simplio_app/view/widgets/total_balance.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
    this.inventoryTab = InventoryTab.coins,
  });

  final InventoryTab inventoryTab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountWalletCubit, AccountWalletState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context).colorScheme.background,
              ],
            ),
          ),
          child: NavigationTabBar(
            tabs: [
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_coins,
                  searchBar: SearchBar<String>(
                    delegate: AssetSearchDelegate.of(context),
                    label: context.locale.inventory_screen_seach_and_add_coins,
                  ),
                  iconData: Icons.pie_chart_outline,
                  iconColor: Theme.of(context).colorScheme.surface,
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    const TotalBalance(balance: 2402.7),
                    const SliverGap(Dimensions.padding20),
                  ],
                  bottomSlivers: [
                    const SliverGap(Dimensions.padding10),
                    const InventoryCoinsContent(),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 500),
                    ),
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_nft,
                  searchBar: SearchBar<String>(
                    delegate: AssetSearchDelegate.of(
                        context), //TODO.. replace by other delegate
                    label: context.locale.inventory_screen_seach_nft,
                  ),
                  iconData: Icons.pie_chart_outline,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    const TotalBalance(balance: 2402.7),
                    const SliverGap(Dimensions.padding20),
                  ],
                  bottomSlivers: [
                    const SliverGap(100)
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_transactions,
                  searchBar: SearchBar<String>(
                    delegate: AssetSearchDelegate.of(
                        context), //TODO.. replace by other delegate
                    label: context.locale.inventory_screen_seach_transactions,
                  ),
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    const TotalBalance(balance: 2402.7),
                    const SliverGap(Dimensions.padding20),
                  ],
                  bottomSlivers: [
                    const SliverGap(100),
                  ])
            ],
          ),
        );
      },
    );
  }
}

enum InventoryTab { coins, nft, transactions }
