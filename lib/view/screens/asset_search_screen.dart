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
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
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
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetSearchScreen extends ScreenWithDialog with PopupDialogMixin {
  AssetSearchScreen({super.key}) : super(panelController: PanelController());

  final TextEditingController searchController = TextEditingController();

  void _searchAssets(CryptoAssetCubit cubit, String criteria) {
    cubit.search(criteria);
  }

  void _addLoadEvent(CryptoAssetCubit cubit, int offset) {
    cubit.loadCryptoAsset(offset);
  }

  @override
  Widget innerBuild(BuildContext context) {
    final cubit = CryptoAssetCubit.builder(
      marketplaceRepository:
          RepositoryProvider.of<MarketplaceRepository>(context),
    );

    searchController.addListener(() {
      _searchAssets(cubit, searchController.text);
    });

    return Search(
      firstPart: context.locale.games_search_screen_search_and_add,
      secondPart: context.locale.games_search_screen_games,
      searchHint: context.locale.games_search_screen_search,
      searchController: searchController,
      autoFocusSearch: true,
      appBarStyle: AppBarStyle.multiColored,
      child: BlocProvider(
        create: (context) => cubit
          ..pagingController.addPageRequestListener(
            (offset) => _addLoadEvent(cubit, offset),
          ),
        child: BlocBuilder<CryptoAssetCubit, CryptoAssetState>(
          builder: (context, state) {
            if (state is CryptoAssetInitial) {
              return const SizedBox.shrink();
            } else if (state is CryptoAssetLoading &&
                cubit.pagingController.itemList?.isEmpty == true) {
              return const Center(
                child: Padding(
                  padding: Paddings.top32,
                  child: ListLoading(),
                ),
              );
            } else {
              return BlocBuilder<AccountWalletCubit, AccountWalletState>(
                buildWhen: (prev, curr) => curr is AccountWalletChanged,
                builder: (context, state) {
                  if (state is! AccountWalletProvided) {
                    throw Exception('No asset wallet found');
                  }

                  // todo: refactor - duplicity with diScover_coins_content.dart
                  return PagedListView.separated(
                    padding: Paddings.top32,
                    physics: const BouncingScrollPhysics(),
                    pagingController: cubit.pagingController,
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
                              : BlocProvider(
                                  create: (context) =>
                                      ExpansionListCubit.builder(),
                                  child: CryptoAssetExpansionList(
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
                                ),
                        );
                      },
                      firstPageProgressIndicatorBuilder: (_) => const Center(
                        child: ListLoading(),
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
                          cubit.reloadAssets();
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
                            cubit.loadCryptoAsset(
                                cubit.pagingController.nextPageKey!);
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
