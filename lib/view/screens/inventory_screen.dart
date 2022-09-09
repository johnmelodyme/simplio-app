import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/inventory_coins_content.dart';
import 'package:simplio_app/view/widgets/navigation_bar_tab_item.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/search_bar_sliver.dart';
import 'package:simplio_app/view/widgets/sio_app_bar.dart';
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
        return NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SioAppBar(
                title: 'Nick name',
                subtitle: 'User Level 1',
              ),
            ];
          },
          body: NavigationTabBar(
            tabs: [
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_coins,
                  iconData: Icons.pie_chart_outline,
                  iconColor: Theme.of(context).colorScheme.surface,
                  topSlivers: [
                    const TotalBalance(balance: 2402.7),
                    const SliverGap(Dimensions.padding10),
                  ],
                  bottomSlivers: [
                    const SliverGap(Dimensions.padding10),
                    const SearchBarSliver(),
                    const InventoryCoinsContent(),
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_nft,
                  iconData: Icons.pie_chart_outline,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                  bottomSlivers: [
                    const SliverToBoxAdapter(child: Text('NFT content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 400,
                    )),
                    const SliverToBoxAdapter(child: Text('NFT content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 200,
                    )),
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_transactions,
                  bottomSlivers: [
                    const SliverToBoxAdapter(child: Text('Invetory content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 400,
                    )),
                    const SliverToBoxAdapter(child: Text('Invetory content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 200,
                    )),
                  ])
            ],
          ),
        );
      },
    );
  }
}

enum InventoryTab { coins, nft, transactions }
