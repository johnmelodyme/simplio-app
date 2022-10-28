import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';

class AssetSendSearchScreen extends StatefulWidget {
  final String assetId;
  final String networkId;

  final TextEditingController searchController = TextEditingController();

  AssetSendSearchScreen({
    required this.assetId,
    required this.networkId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AssetSendSearchScreen();
}

class _AssetSendSearchScreen extends State<AssetSendSearchScreen> {
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
        .read<AssetSendFormCubit>()
        .loadSearchInitialData(state.wallet.wallets);
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
        () => setState(() => _search(widget.searchController.text)));

    return Search(
      firstPart: context.locale.common_search,
      secondPart: context.locale.asset_exchange_screen_coin_label_lc,
      searchHint: context.locale.asset_search_screen_search,
      searchController: widget.searchController,
      appBarStyle: AppBarStyle.multiColored,
      child: BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
        buildWhen: (prev, curr) =>
            curr.response is AssetSearchSuccess ||
            curr.response is AssetSearchFailure ||
            curr.response is AssetSearchPending,
        builder: (context, state) {
          final response = state.response;

          if (response is AssetSearchSuccess) {
            availableWallets = response.availableWallets;
            _search(widget.searchController.text);

            return SingleChildScrollView(
              child: AssetWalletExpansionList(
                assetWallets: filteredWallets,
                onTap: (assetWallet, networkWallet) {
                  final cubit = context.read<AssetSendFormCubit>();
                  cubit.changeFormValue(
                    sourceAssetWallet: assetWallet,
                    sourceNetworkWallet: networkWallet,
                  );
                  cubit.clearAmount();

                  GoRouter.of(context).pop();
                },
              ),
            );
          }

          if (response is AssetSearchFailure) {
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

  void _search(String text) {
    filteredWallets = availableWallets.where((element) {
      final assetDetail = Assets.getAssetDetail(element.assetId);

      return assetDetail.name.toLowerCase().contains(text.toLowerCase()) ||
          assetDetail.ticker.toLowerCase().contains(text.toLowerCase());
    }).toList();
  }
}
