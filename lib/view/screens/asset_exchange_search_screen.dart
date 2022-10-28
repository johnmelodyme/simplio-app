import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';

class AssetExchangeSearchScreen extends StatefulWidget {
  final String assetId;
  final String networkId;
  final bool fromSearch;
  final bool targetSearch;

  final TextEditingController searchController = TextEditingController();

  AssetExchangeSearchScreen({
    required this.assetId,
    required this.networkId,
    required this.fromSearch,
    required this.targetSearch,
    super.key,
  }) : assert(
          (fromSearch || targetSearch) && (!fromSearch || !targetSearch),
          'Only one out of fromSearch and targetSearch needs to be selected',
        );

  @override
  State<StatefulWidget> createState() => _AssetExchangeSearchScreen();
}

class _AssetExchangeSearchScreen extends State<AssetExchangeSearchScreen> {
  List<AssetWallet> filteredWallets = [];
  List<AssetWallet> availableWallets = [];

  @override
  Widget build(BuildContext context) {
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    widget.searchController.addListener(
        () => setState(() => _search(widget.searchController.text)));

    return Search(
      firstPart: context.locale.common_search,
      secondPart: context.locale.asset_exchange_screen_coin_label_lc,
      searchHint: context.locale.asset_search_screen_search,
      searchController: widget.searchController,
      appBarStyle: AppBarStyle.multiColored,
      child: BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
        builder: (context, state) {
          final response = state.response;
          if (response is SearchAssetsLoading) {
            return const Center(
              child: Padding(
                padding: Paddings.bottom32,
                child: ListLoading(),
              ),
            );
          }

          if (response is SearchAssetsFailure) {
            // todo: add proper error handling
          }

          availableWallets = widget.fromSearch
              ? state.availableFromAssets
              : state.availableTargetAssets;

          _search(widget.searchController.text);

          return SingleChildScrollView(
            child: AssetWalletExpansionList(
              assetWallets: filteredWallets,
              onTap: (assetWallet, networkWallet) {
                if (widget.fromSearch) {
                  context.read<AssetExchangeFormCubit>().changeAssetWallets(
                        sourceAssetWallet: assetWallet,
                        sourceNetworkWallet: networkWallet,
                      );

                  context
                      .read<AssetExchangeFormCubit>()
                      .loadAvailableTargetPairs(
                        availableWallets,
                        assetWallet.assetId,
                        networkWallet.networkId,
                      );
                } else {
                  context.read<AssetExchangeFormCubit>().changeAssetWallets(
                        targetAssetWallet: assetWallet,
                        targetNetworkWallet: networkWallet,
                      );
                }
                GoRouter.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  void _search(String text) {
    filteredWallets = availableWallets.where((element) {
      final assetDetail = Assets.getAssetDetail(element.assetId);

      return assetDetail.name.toLowerCase().contains(text.toLowerCase()) ||
          assetDetail.ticker.toLowerCase().contains(text.toLowerCase());
    }).toList();
  }
}
