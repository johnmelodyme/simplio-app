import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc_event.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_search_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/asset_search_item.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/screen_with_dialog.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class AssetSearchScreen extends ScreenWithDialog with PopupDialogMixin {
  AssetSearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  void _searchAssets(CryptoAssetSearchBloc bloc, String criteria) {
    bloc.add(SearchCryptoAssetsEvent(criteria));
  }

  void _addLoadEvent(CryptoAssetSearchBloc bloc, int offset) {
    bloc.add(LoadCryptoAssetsEvent(page: offset));
  }

  @override
  Widget innerBuild(BuildContext context) {
    bool addedPageRequestLister = false;

    final bloc = CryptoAssetSearchBloc.builder(
      marketplaceRepository:
          RepositoryProvider.of<MarketplaceRepository>(context),
    );

    searchController.addListener(() {
      _searchAssets(bloc, searchController.text);
    });

    return Search(
      firstPart: context.locale.asset_search_screen_search_and_add,
      secondPart: context.locale.asset_search_screen_coins,
      searchHint: context.locale.asset_search_screen_search,
      searchController: searchController,
      autoFocusSearch: true,
      appBarStyle: AppBarStyle.multiColored,
      child: BlocProvider(
        create: (context) => bloc,
        child: BlocConsumer<CryptoAssetSearchBloc, CryptoAssetState>(
          listener: (context, state) {
            if (state is CryptoAssetLoaded && !addedPageRequestLister) {
              addedPageRequestLister = true;
              bloc.pagingController.addPageRequestListener(
                (offset) => _addLoadEvent(bloc, offset),
              );
            }
          },
          builder: (context, state) {
            if (state is CryptoAssetInitial) {
              return const SizedBox.shrink();
            } else if (state is CryptoAssetLoading &&
                bloc.pagingController.itemList?.isEmpty == true) {
              return Column(
                children: const [
                  Center(
                    child: Padding(
                      padding: Paddings.top32,
                      child: ListLoading(),
                    ),
                  ),
                ],
              );
            } else {
              return BlocBuilder<AccountWalletCubit, AccountWalletState>(
                buildWhen: (prev, curr) => curr is AccountWalletChanged,
                builder: (context, state) {
                  if (state is! AccountWalletProvided) {
                    throw Exception('No asset wallet found');
                  }

                  // todo: refactor - duplicity with discover_coins_content.dart
                  return PagedListView.separated(
                    padding: Paddings.top32,
                    physics: const BouncingScrollPhysics(),
                    pagingController: bloc.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Asset>(
                      itemBuilder: (context, item, index) {
                        final asset = Assets.getAssetDetail(item.assetId);

                        return Padding(
                          padding: Paddings.horizontal16,
                          child: item.networks.length == 1
                              ? AssetSearchItem(
                                  label: item.name,
                                  priceLabel:
                                      item.price.getThousandValueWithCurrency(
                                    currency:
                                        'USD', //TODO.. replace by real currency
                                    locale: Intl.getCurrentLocale(),
                                  ),
                                  assetIcon: asset.style.icon,
                                  assetAction: [
                                    AssetAction.buy,
                                    state.wallet.isNetworkWalletEnabled(
                                            assetId: item.assetId,
                                            networkId:
                                                item.networks.first.networkId)
                                        ? AssetAction.remove
                                        : AssetAction.addToInventory,
                                  ],
                                  onActionPressed: (AssetAction assetAction) =>
                                      _tapFunction(
                                    context,
                                    item.networks.first
                                        .toNetworkData(item.assetId),
                                    assetAction,
                                  ),
                                )
                              : CryptoAssetExpansionList(
                                  children: [item.toCryptoAsset()],
                                  withoutPadding: true,
                                  onTap: (NetworkData data,
                                          AssetAction assetAction) =>
                                      _tapFunction(
                                    context,
                                    item.networks.first
                                        .toNetworkData(item.assetId),
                                    assetAction,
                                  ),
                                ),
                        );
                      },
                      firstPageProgressIndicatorBuilder: (_) => Column(
                        children: const [
                          Center(
                            child: Padding(
                              padding: Paddings.bottom32,
                              child: ListLoading(),
                            ),
                          ),
                        ],
                      ),
                      newPageProgressIndicatorBuilder: (_) => const Center(
                        child: Padding(
                          padding: Paddings.bottom32,
                          child: ListLoading(),
                        ),
                      ),
                      firstPageErrorIndicatorBuilder: (_) => TapToRetryLoader(
                        isLoading: state is CryptoAssetLoading,
                        loadingIndicator: const Center(
                          child: Padding(
                            padding: Paddings.bottom32,
                            child: ListLoading(),
                          ),
                        ),
                        onTap: () {
                          bloc.add(const ReloadCryptoAssetsEvent());
                        },
                      ),
                      noMoreItemsIndicatorBuilder: (_) => Gaps.gap20,
                      noItemsFoundIndicatorBuilder: (_) =>
                          const SizedBox.shrink(),
                      newPageErrorIndicatorBuilder: (_) => Padding(
                        padding: Paddings.bottom32,
                        child: TapToRetryLoader(
                          isLoading: state is CryptoAssetLoading,
                          loadingIndicator: const Center(
                            child: Padding(
                              padding: Paddings.bottom32,
                              child: ListLoading(),
                            ),
                          ),
                          onTap: () {
                            bloc.add(LoadCryptoAssetsEvent(
                                page: bloc.pagingController.nextPageKey!));
                          },
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => Gaps.gap10,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _tapFunction(
    BuildContext context,
    NetworkData data,
    AssetAction assetAction,
  ) {
    context.read<DialogCubit>().showDialog((proceed) async {
      if (proceed) {
        switch (assetAction) {
          case AssetAction.buy:
          case AssetAction.addToInventory:
            await context
                .read<AccountWalletCubit>()
                .enableNetworkWallet(
                    assetId: data.assetId, networkId: data.networkId)
                .then((_) {
              if (assetAction == AssetAction.buy) {
                GoRouter.of(context).pushNamed(
                  AuthenticatedRouter.assetBuy,
                  params: {
                    'assetId': data.assetId.toString(),
                    'networkId': data.networkId.toString(),
                  },
                );
              }
            });
            break;
          case AssetAction.remove:
            await context.read<AccountWalletCubit>().disableNetworkWallet(
                  assetId: data.assetId,
                  networkId: data.networkId,
                );
        }
      }
    },
        assetAction == AssetAction.remove
            ? DialogType.removeCoin
            : DialogType.createCoin);
  }
}
