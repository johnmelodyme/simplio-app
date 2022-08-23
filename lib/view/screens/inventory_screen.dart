import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/app_bar/sio_app_bar.dart';
import 'package:simplio_app/view/navigation_bar/navigation_bar_tab_item.dart';
import 'package:simplio_app/view/navigation_bar/navigation_tab_bar.dart';

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
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SioAppBar(
                title: 'Nick name',
                subtitle: 'User Level 1',
              ),
            ];
          },
          body: NavigationTabBar(
            addSearchBar: true,
            tabs: [
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_coins,
                  iconData: Icons.pie_chart_outline,
                  iconColor: Theme.of(context).colorScheme.surface,
                  pageSlivers: [
                    const SliverToBoxAdapter(child: Text('Coins content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 400,
                    )),
                    const SliverToBoxAdapter(child: Text('Coins content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 200,
                    )),
                    const SliverToBoxAdapter(child: Text('Coins content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 200,
                    )),
                    const SliverToBoxAdapter(child: Text('Coins content')),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 200,
                    )),
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_nft,
                  iconData: Icons.pie_chart_outline,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                  pageSlivers: [
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
                  pageSlivers: [
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
