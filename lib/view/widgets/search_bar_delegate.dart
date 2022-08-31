import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  final BuildContext context;

  SearchBarDelegate.of(this.context) : super();

  @override
  String? get searchFieldLabel => context.locale.searchAllAssetsInputLabel;

  @override
  List<Widget>? buildActions(BuildContext context) => [];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, ''),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
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
