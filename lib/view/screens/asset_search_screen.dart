import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_search_item.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/screen_with_dialog.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetSearchScreen extends ScreenWithDialog {
  AssetSearchScreen({super.key})
      : super(
          panelController: PanelController(),
        );

  final TextEditingController searchController = TextEditingController();

  @override
  Widget innerBuild(BuildContext context) {
    final cubit = context.read<CryptoAssetCubit>();

    searchController.addListener(
      () {
        context.read<CryptoAssetCubit>().queryCryptoAsset(
              query: searchController.text,
            );
      },
    );

    return Search(
      firstPart: context.locale.asset_search_screen_search_and_add,
      secondPart: context.locale.asset_search_screen_coins,
      searchHint: context.locale.asset_search_screen_search,
      searchController: searchController,
      appBarStyle: AppBarStyle.twoLined,
      child: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<CryptoAssetCubit, CryptoAssetState>(
          builder: (context, state) {
            if (state is CryptoAssetLoaded) {
              return BlocBuilder<AccountWalletCubit, AccountWalletState>(
                  buildWhen: (prev, curr) => curr is AccountWalletChanged,
                  builder: (context, accountWalletState) {
                    if (accountWalletState is! AccountWalletProvided) {
                      throw Exception('No asset wallet found');
                    }
                    return SingleChildScrollView(
                      padding: Paddings.top20,
                      child: CryptoAssetExpansionList(
                        children: state.assets,
                        onTap:
                            (NetworkData data, AssetAction assetAction) async {
                          // in case the wallet is already enabled user clicked on buy action
                          if (accountWalletState.wallet.isNetworkWalletEnabled(
                              assetId: data.assetId,
                              networkId: data.networkId)) {
                            GoRouter.of(context).replaceNamed(
                              AuthenticatedRouter.assetBuy,
                              params: {
                                'assetId': data.assetId.toString(),
                                'networkId': data.networkId.toString(),
                              },
                            );
                          } else {
                            context.read<DialogCubit>().showDialog(
                              (proceed) async {
                                if (proceed) {
                                  await context
                                      .read<AccountWalletCubit>()
                                      .enableNetworkWallet(
                                          assetId: data.assetId,
                                          networkId: data.networkId)
                                      .then((_) {
                                    if (assetAction == AssetAction.buy) {
                                      GoRouter.of(context).replaceNamed(
                                        AuthenticatedRouter.assetBuy,
                                        params: {
                                          'assetId': data.assetId.toString(),
                                          'networkId':
                                              data.networkId.toString(),
                                        },
                                      );
                                    }
                                  });
                                }
                              },
                              DialogType.createCoin,
                            );
                          }
                        },
                      ),
                    );
                  });
            }

            // TODO - implement logic with error
            if (state is CryptoAssetLoadedWithError) {}

            if (state is CryptoAssetLoading) {
              return const Center(
                child: ListLoading(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
