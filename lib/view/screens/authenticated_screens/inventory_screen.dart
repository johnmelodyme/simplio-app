import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/mixins/currency_getter_mixin.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_detail_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/discovery_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/discovery_screen.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/no_content_placeholder.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/total_balance_overview.dart';
import 'package:simplio_app/view/widgets/transactions_content.dart';
import 'package:sio_glyphs/sio_icons.dart';

class InventoryScreen extends StatefulWidget with CurrencyGetter {
  const InventoryScreen({
    super.key,
    this.tab = InventoryTab.coins,
  });

  final InventoryTab tab;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Timer? _timer;

  void startUpdateBalanceTimer(
    DateTime updatedAt, {
    required VoidCallback onDone,
  }) {
    final threshold = updatedAt.add(
      Constants.updateBalanceThresholdDuration,
    );

    _timer?.cancel();

    _timer = Timer(
      Duration(
        seconds: max(threshold.difference(DateTime.now()).inSeconds, 0),
      ),
      onDone,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: BlocBuilder<AccountWalletCubit, AccountWalletState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          final currency = widget.getCurrency(context);

          if (state is! AccountWalletProvided) {
            return const SizedBox.shrink();
          }

          if (state is! AccountWalletUpdatedWithError) {
            startUpdateBalanceTimer(
              state.wallet.updatedAt,
              onDone: () => _updateAccountWalletBalance(context),
            );
          }

          return NavigationTabBar(
            currentTab: widget.tab.index,
            tabs: [
              NavigationBarTabItem(
                label: context.locale.inventory_tab_coins,
                iconData: SioIcons.coins,
                iconColor: SioColors.coins,
                topSlivers: [
                  const SliverGap(Dimensions.padding16),
                  TotalBalanceOverview(
                    balance: state.wallet.fiatBalance,
                    currency: currency,
                  ),
                  const SliverGap(Dimensions.padding20),
                ],
                bottomSlivers: [
                  const SliverGap(Dimensions.padding10),
                  const _InventoryCoinsContent(),
                  const SliverFillRemaining(),
                  const SliverGap(Dimensions.padding20),
                ],
                onRefresh: () => _updateAccountWalletBalance(context),
              ),
              NavigationBarTabItem(
                  label: context.locale.inventory_tab_nft,
                  iconData: SioIcons.nft,
                  iconColor: SioColors.nft,
                  topSlivers: [
                    const SliverGap(Dimensions.padding16),
                    TotalBalanceOverview(
                      balance: state.wallet.fiatBalance,
                      currency: currency,
                    ),
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
                    TotalBalanceOverview(
                      balance: state.wallet.fiatBalance,
                      currency: currency,
                    ),
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

  Future<void> _updateAccountWalletBalance(BuildContext context) async {
    final s = context.read<AccountCubit>().state;
    if (s is! AccountProvided) return;

    await context.read<AccountWalletCubit>().updateAccountWalletBalance(
          currency: s.account.settings.currency,
        );
  }
}

enum InventoryTab { coins, nft, transactions }

class _InventoryCoinsContent extends StatelessWidget with CurrencyGetter {
  const _InventoryCoinsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountWalletCubit, AccountWalletState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return state is! AccountWalletProvided
            ? SliverFillRemaining(
                child: Center(
                child: Text(
                  context.locale.inventory_screen_no_wallets_label,
                ),
              ))
            : SliverList(
                delegate: SliverChildListDelegate([
                AssetWalletExpansionList.fromAssetWallets(
                  currency: getCurrency(context),
                  wallets: state.wallet.enabled,
                  onTap: (value) {
                    if (value.length < 2) return;

                    GoRouter.of(context).pushNamed(
                      AssetDetailRoute.name,
                      params: {
                        'assetId': value.first.toString(),
                        'networkId': value.last.toString(),
                      },
                    );
                  },
                ),
              ]));
      },
    );
  }
}
