import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/mixins/currency_getter_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class AssetSelectionScreenArguments {
  final AssetId assetId;
  final NetworkId networkId;
  final void Function(
    AssetId assetId,
    NetworkId networkId,
  )? onSelect;

  const AssetSelectionScreenArguments({
    required this.assetId,
    required this.networkId,
    this.onSelect,
  });
}

class AssetSelectionScreen extends StatelessWidget with CurrencyGetter {
  final AssetSelectionScreenArguments arguments;

  const AssetSelectionScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: BackGradient4(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: FixedHeightItemDelegate(
                fixedHeight: Constants.appBarHeight +
                    MediaQuery.of(context).viewPadding.top,
                child: ColorizedAppBar(
                  title: 'Exchange ^from',
                  onBackTap: Navigator.of(context).pop,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  BlocBuilder<AccountWalletCubit, AccountWalletState>(
                    builder: (context, state) {
                      return AssetWalletExpansionList.fromAssetWallets(
                        currency: getCurrency(context),
                        wallets: _filter(
                          state is AccountWalletProvided
                              ? state.wallet.enabled
                              : const [],
                          assetId: arguments.assetId,
                          networkId: arguments.networkId,
                        ),
                        onTap: (value) {
                          arguments.onSelect?.call(value.first, value.last);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AssetWallet> _filter(
    List<AssetWallet> wallets, {
    required AssetId assetId,
    required NetworkId networkId,
  }) {
    return wallets;
    // return wallets.fold<List<AssetWallet>>([], (acc, curr) {
    //   return acc;
    // });
  }
}
