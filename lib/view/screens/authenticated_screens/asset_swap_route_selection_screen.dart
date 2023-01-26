import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/mixins/currency_getter_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class AssetSwapRouteSelectionScreenArguments {
  final List<SwapRoute> routes;
  final void Function(SwapAsset route, List<SwapRoute> routes)? onSelect;

  const AssetSwapRouteSelectionScreenArguments({
    required this.routes,
    this.onSelect,
  });
}

class AssetSwapRouteSelectionScreen extends StatelessWidget
    with CurrencyGetter {
  final AssetSwapRouteSelectionScreenArguments arguments;

  const AssetSwapRouteSelectionScreen({
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
                  title: 'Exchange ^to',
                  onBackTap: Navigator.of(context).pop,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  BlocBuilder<AccountWalletCubit, AccountWalletState>(
                    builder: (context, state) {
                      if (state is! AccountWalletProvided) {
                        return const SizedBox.shrink();
                      }

                      return AssetWalletExpansionList.fromSwapAsset(
                        currency: getCurrency(context),
                        accountWallet: state.wallet,
                        assets: arguments.routes.map((e) => e.targetAsset),
                        onTap: (value) {
                          arguments.onSelect?.call(value, arguments.routes);
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
}
