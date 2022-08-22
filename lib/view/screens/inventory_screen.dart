import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/view/navigation_bar/navigation_bar_tab_item.dart';
import 'package:simplio_app/view/navigation_bar/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/appbar_search.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
    this.inventoryTab = InventoryTab.coins,
  });

  final InventoryTab inventoryTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: AppBarSearch<String>(
          delegate: _AssetSearchDelegate.of(context),
          label: context.locale.searchAllAssetsInputLabel,
        ),
      ),
      body: BlocBuilder<AccountWalletCubit, AccountWalletState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return NavigationTabBar(
            addTopGap: false,
            currentTab: inventoryTab.index,
            tabs: [
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_coins,
                  iconData: Icons.pie_chart_outline,
                  pageSlivers: [
                    const SliverToBoxAdapter(child: Text('Coins content'))
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_nft,
                  iconData: Icons.pie_chart_outline,
                  pageSlivers: [
                    const SliverToBoxAdapter(child: Text('NFT content'))
                  ]),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_transactions,
                  pageSlivers: [
                    const SliverToBoxAdapter(
                        child: Text('Transactions content'))
                  ])
            ],
          );
        },
      ),
    );
  }
}

class _AssetSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;

  _AssetSearchDelegate.of(this.context) : super();

  @override
  String? get searchFieldLabel => context.locale.searchAllAssetsInputLabel;

  @override
  List<Widget>? buildActions(_) => [];

  @override
  Widget? buildLeading(_) {
    return IconButton(
        onPressed: () => close(context, ''),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(_) => buildSuggestions(context);

  @override
  Widget buildSuggestions(_) {
    final ctx = context.read<CryptoAssetCubit>();

    return BlocProvider.value(
      value: ctx,
      child: BlocBuilder<CryptoAssetCubit, CryptoAssetState>(
        builder: (context, state) {
          if (state is CryptoAssetInitial) ctx.loadCryptoAsset();

          if (state is CryptoAssetLoaded) {
            return SingleChildScrollView(
              child: CryptoAssetExpansionList(
                children: queryAssets(state.assets),
                onTap: (data) {
                  context.read<AccountWalletCubit>().addNetworkWallet(data);
                },
              ),
            );
          }

          // TODO - implement logic with error
          if (state is CryptoAssetLoadedWithError) {}

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    backgroundColor: Theme.of(context).indicatorColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<CryptoAssetData> queryAssets(List<CryptoAssetData> data) {
    return data
        .where((d) =>
            d.name.toLowerCase().contains(query.toLowerCase()) ||
            d.ticker.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

enum InventoryTab { coins, nft, transactions }
