import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';

class AssetBuySearchScreen extends StatefulWidget {
  final String assetId;
  final String networkId;

  final TextEditingController searchController = TextEditingController();

  AssetBuySearchScreen({
    required this.assetId,
    required this.networkId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AssetBuySearchScreen();
}

class _AssetBuySearchScreen extends State<AssetBuySearchScreen> {
  List<AssetWallet> filteredWallets = [];
  List<AssetWallet> availableWallets = [];

  @override
  void initState() {
    final state = context.read<AccountWalletCubit>().state;

    if (state is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    context
        .read<AssetBuyFormCubit>()
        .loadFromSearchInitialData(state.wallet.wallets);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    widget.searchController.addListener(
        () => setState(() => search(widget.searchController.text)));

    return Search(
      firstPart: context.locale.common_search,
      secondPart: context.locale.asset_exchange_screen_coin_label_lc,
      searchHint: context.locale.asset_search_screen_search,
      searchController: widget.searchController,
      appBarStyle: AppBarStyle.multiColored,
      child: BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
        buildWhen: (prev, curr) =>
            curr.response is AssetSearchFromSuccess ||
            curr.response is AssetSearchFromFailure ||
            curr.response is AssetSearchFromPending,
        builder: (context, state) {
          final response = state.response;
          if (response is AssetSearchFromSuccess) {
            availableWallets = response.availableWallets;
            search(widget.searchController.text);

            return SingleChildScrollView(
              child: AssetWalletExpansionList(
                assetWallets: filteredWallets,
                onTap: (assetWallet, networkWallet) {
                  context.read<AssetBuyFormCubit>().changeFormValue(
                        sourceAssetWallet: assetWallet,
                        sourceNetworkWallet: networkWallet,
                      );

                  GoRouter.of(context).pop();
                },
              ),
            );
          }

          if (response is AssetSearchFromFailure) {
            // todo: add proper error handling
          }

          return const Center(
            child: Padding(
              padding: Paddings.bottom32,
              child: ListLoading(),
            ),
          );
        },
      ),
    );
  }

  void search(String text) {
    filteredWallets = availableWallets.where((element) {
      final assetDetail = Assets.getAssetDetail(element.assetId);

      return assetDetail.name.toLowerCase().contains(text.toLowerCase()) ||
          assetDetail.ticker.toLowerCase().contains(text.toLowerCase());
    }).toList();
  }
}
