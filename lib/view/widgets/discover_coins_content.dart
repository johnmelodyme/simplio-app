import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc_event.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/dialogs/asset_confirmation_dialog.dart';
import 'package:simplio_app/view/widgets/asset_search_item.dart';
import 'package:simplio_app/view/widgets/crypto_asset_expansion_list.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

// TODO - rename coins to assets. Coins and tokens = assets.
class DiscoverCoinsContent extends StatefulWidget {
  const DiscoverCoinsContent({super.key});

  @override
  State<DiscoverCoinsContent> createState() => _DiscoverCoinsContentState();
}

class _DiscoverCoinsContentState extends State<DiscoverCoinsContent> {
  late CryptoAssetBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = context.read<CryptoAssetBloc>()
      ..pagingController.addPageRequestListener(_addLoadEvent);
  }

  void _addLoadEvent(int offset) =>
      bloc.add(LoadCryptoAssetsEvent(page: offset));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CryptoAssetBloc, CryptoAssetState>(
      builder: (context, state) {
        return BlocBuilder<AccountWalletCubit, AccountWalletState>(
          buildWhen: (prev, current) => current is AccountWalletUpdated,
          builder: (context, state) {
            if (state is! AccountWalletProvided) {
              throw Exception('No asset wallet found');
            }

            return PagedSliverList.separated(
              pagingController: bloc.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Asset>(
                itemBuilder: (context, item, index) {
                  final asset = Assets.getAssetDetail(item.assetId);
                  Future<void> tapFunction(
                      NetworkData data, AssetAction assetAction) async {
                    //TODO.. refactor asset actions
                    switch (assetAction) {
                      case AssetAction.buy:
                      case AssetAction.addToInventory:
                        _showAssetConfirmation(assetAction)
                            .then((confirmed) async {
                          if (!confirmed) return;

                          await context
                              .read<AccountWalletCubit>()
                              .enableNetworkWallet(
                                  assetId: data.assetId,
                                  networkId: data.networkId)
                              .then((_) {
                            if (assetAction == AssetAction.buy) {
                              // TODO: add buy flow when buy is implemented.
                            }
                          });
                        });

                        break;
                      case AssetAction.remove:
                        _showAssetConfirmation(assetAction)
                            .then((confirmed) async {
                          if (!confirmed) return;
                          await context
                              .read<AccountWalletCubit>()
                              .disableNetworkWallet(
                                assetId: data.assetId,
                                networkId: data.networkId,
                              );
                        });
                    }
                  }

                  return Padding(
                    padding: Paddings.horizontal16,
                    child: item.networks.length == 1
                        ? AssetSearchItem(
                            label: item.name,
                            // TODO - Provide BigDecimal dirrectly from `item`.
                            fiatPrice: BigDecimal.fromDouble(item.price),
                            currency: 'USD',
                            assetIcon: asset.style.icon,
                            assetAction: [
                              AssetAction.buy,
                              state.wallet.isNetworkWalletEnabled(
                                      assetId: item.assetId,
                                      networkId: item.networks.first.networkId)
                                  ? AssetAction.remove
                                  : AssetAction.addToInventory,
                            ],
                            onActionPressed: (AssetAction assetAction) =>
                                tapFunction(
                                    item.networks.first
                                        .toNetworkData(item.assetId),
                                    assetAction),
                          )
                        : BlocProvider(
                            create: (context) => ExpansionListCubit.builder(),
                            child: CryptoAssetExpansionList(
                              children: [item.toCryptoAsset()],
                              withoutPadding: true,
                              onTap:
                                  (NetworkData data, AssetAction assetAction) =>
                                      tapFunction(
                                          item.networks.first
                                              .toNetworkData(item.assetId),
                                          assetAction),
                            ),
                          ),
                  );
                },
                firstPageProgressIndicatorBuilder: (_) => Column(
                  children: const [
                    Center(child: ListLoading()),
                    Spacer(),
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
                noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
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
      },
    );
  }

  Future<bool> _showAssetConfirmation(AssetAction assetAction) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AssetConfirmationDialog(
          dialogType: assetAction == AssetAction.remove
              ? DialogType.removeAsset
              : DialogType.createAsset,
        );
      },
    );

    return result ?? false;
  }

  @override
  void dispose() {
    bloc.pagingController.removePageRequestListener(_addLoadEvent);
    super.dispose();
  }
}
