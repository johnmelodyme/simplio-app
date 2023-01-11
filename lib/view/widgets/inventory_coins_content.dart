import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_detail_route.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';

// TODO - why is it a stateful widget?
// TODO - think of making a new view layer for screen content. Ideally. As it is not reusable, keep it inside a screen as s private widget.
class InventoryCoinsContent extends StatefulWidget {
  const InventoryCoinsContent({Key? key}) : super(key: key);

  @override
  State<InventoryCoinsContent> createState() => _InventoryCoinsContentState();
}

class _InventoryCoinsContentState extends State<InventoryCoinsContent> {
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
            : SliverToBoxAdapter(
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
              ));
      },
    );
  }
}
