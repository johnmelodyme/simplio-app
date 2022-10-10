import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/search.dart';

class AssetSearchScreen extends StatelessWidget {
  AssetSearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctx = context.read<CryptoAssetCubit>();

    searchController.addListener(
      () => {
        context.read<CryptoAssetCubit>().queryCryptoAsset(
              query: searchController.text,
            ),
      },
    );

    return Search(
      firstPart: context.locale.asset_search_screen_search_and_add,
      secondPart: context.locale.asset_search_screen_coins,
      searchHint: context.locale.asset_search_screen_search,
      searchController: searchController,
      appBarStyle: AppBarStyle.twoLined,
      child: BlocProvider.value(
        value: ctx,
        child: BlocBuilder<CryptoAssetCubit, CryptoAssetState>(
          builder: (context, state) {
            if (state is CryptoAssetInitial) ctx.loadCryptoAsset();

            if (state is CryptoAssetLoaded) {
              return SingleChildScrollView(
                child: CryptoAssetExpansionList(
                  children: (state.assets),
                  onTap: (data) {
                    context
                        .read<AccountWalletCubit>()
                        .enableNetworkWallet(data);
                  },
                ),
              );
            }

            // TODO - implement logic with error
            if (state is CryptoAssetLoadedWithError) {}

            return const Center(
              child: ListLoading(),
            );
          },
        ),
      ),
    );
  }
}
