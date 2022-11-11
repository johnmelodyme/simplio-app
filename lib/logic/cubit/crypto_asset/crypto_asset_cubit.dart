import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'crypto_asset_state.dart';

class CryptoAssetCubit extends Cubit<CryptoAssetState> {
  final MarketplaceRepository _marketplaceRepository;
  final PagingController<int, Asset> pagingController =
      PagingController(firstPageKey: 1);

  String _currentlySearched = '';

  CryptoAssetCubit._(this._marketplaceRepository) : super(CryptoAssetInitial());

  CryptoAssetCubit.builder({
    required MarketplaceRepository marketplaceRepository,
  }) : this._(marketplaceRepository);

  Future<void> loadCryptoAsset(int pageKey) async {
    _emitSafely(CryptoAssetLoading());
    try {
      final assets = await _marketplaceRepository.assetSearch(
        SearchAssetsRequest(
          page: pageKey,
          pageSize: Constants.pageSizeAssets,
          currency: 'USD', // todo: use correct fiat
          name: _currentlySearched,
          categories: [],
        ),
      );

      if (assets.length < Constants.pageSizeAssets) {
        pagingController.appendLastPage(assets);
      } else {
        pagingController.appendPage(assets, pageKey + 1);
      }

      _emitSafely(CryptoAssetLoaded(
          assets: assets.map((e) => e.toCryptoAsset()).toList()));
    } on Exception catch (e) {
      _emitSafely(CryptoAssetLoadedWithError(error: e));
    }
  }

  void reloadAssets() {
    _emitSafely(CryptoAssetLoading());
    pagingController.refresh();
    _emitSafely(CryptoAssetInitial());
  }

  void search(String criteria) async {
    if (criteria != _currentlySearched) {
      _currentlySearched = criteria;
      if (pagingController.itemList?.isNotEmpty == true) {
        reloadAssets();
      } else {
        loadCryptoAsset(pagingController.firstPageKey);
      }
    }
  }

  void _emitSafely(CryptoAssetState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
