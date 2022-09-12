import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';

class AssetSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;

  AssetSearchDelegate.of(this.context) : super();

  @override
  List<Widget>? buildActions(_) => [];

  @override
  Widget? buildLeading(_) {
    return IconButton(
        onPressed: () => close(context, ''),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(_) => buildSuggestions(context);

  @override
  Widget buildSuggestions(_) {
    final ctx = context.read<CryptoAssetCubit>();

    return BlocProvider.value(
      value: ctx,
      child: BlocBuilder<CryptoAssetCubit, CryptoAssetState>(
        builder: (context, state) {
          if (state is CryptoAssetInitial) ctx.loadCryptoAsset();

          if (state is CryptoAssetLoaded) {
            return SingleChildScrollView(
              child: CryptoAssetExpansionList(
                children: queryAssets(state.assets),
                onTap: (data) {
                  context.read<AccountWalletCubit>().addNetworkWallet(data);
                },
              ),
            );
          }

          // TODO - implement logic with error
          if (state is CryptoAssetLoadedWithError) {}

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    backgroundColor: Theme.of(context).indicatorColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<CryptoAssetData> queryAssets(List<CryptoAssetData> data) {
    return data
        .where((d) =>
            d.name.toLowerCase().contains(query.toLowerCase()) ||
            d.ticker.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
