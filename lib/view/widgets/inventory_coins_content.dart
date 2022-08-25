import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';

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
                  context.locale.noWalletsLabel,
                ),
              ))
            : SliverToBoxAdapter(
                child: AssetWalletExpansionList(
                children: state.wallet.wallets,
              ));
      },
    );
  }
}
