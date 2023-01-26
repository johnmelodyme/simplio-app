import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_detail_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/discovery_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/discovery_screen.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';
import 'package:simplio_app/view/widgets/no_content_placeholder.dart';

// TODO - think of making a new view layer for screen content. Ideally. As it is not reusable, keep it inside a screen as s private widget.
class InventoryCoinsContent extends StatelessWidget {
  const InventoryCoinsContent({Key? key}) : super(key: key);

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
            : state.wallet.enabled.isEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.only(top: 90),
                    sliver: NoContentPlaceholder(
                      title: context
                          .locale.inventory_screen_coins_empty_list_label,
                      buttonLabel:
                          context.locale.inventory_screen_discover_new_coins,
                      onPressed: () {
                        GoRouter.of(context).goNamed(
                          DiscoveryRoute.name,
                          extra: DiscoveryTab.coins,
                        );
                      },
                    ),
                  )
                : SliverFillRemaining(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: AssetWalletExpansionList.fromAssetWallets(
                        wallets: state.wallet.enabled,
                        onTap: (value) {
                          if (value.length < 2) return;

                          // TODO - GoRouter should not be used in Widget. Instead it should be visible on screeens.
                          GoRouter.of(context).pushNamed(
                            AssetDetailRoute.name,
                            params: {
                              'assetId': value.first.toString(),
                              'networkId': value.last.toString(),
                            },
                          );
                        },
                      ),
                    ),
                  );
      },
    );
  }
}
