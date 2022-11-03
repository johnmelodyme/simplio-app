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

  bool _isDisposed = false;

  CryptoAssetCubit._(
    this._marketplaceRepository,
  ) : super(const CryptoAssetInitial());

  CryptoAssetCubit.builder({
    required MarketplaceRepository marketplaceRepository,
  }) : this._(marketplaceRepository);

  Future<void> loadCryptoAsset({int page = 1, bool readCache = true}) async {
    emit(const CryptoAssetLoading());
    try {
      final assets = await _marketplaceRepository.assetSearch(
        SearchAssetsRequest(
          page: page,
          pageSize: 100,
          currency: 'USD', // todo: use correct fiat
          name: '', categories: [],
        ),
      );

      if (assets.length < Constants.pageSizeGames) {
        pagingController.appendLastPage(assets);
      } else {
        pagingController.appendPage(assets, page + 1);
      }

      _emitSafely(CryptoAssetLoaded(
          assets: assets.map((e) => e.toCryptoAsset()).toList()));
    } on Exception catch (e) {
      _emitSafely(CryptoAssetLoadedWithError(error: e));
    }
  }

  void reloadGames() async {
    pagingController.refresh();
    await loadCryptoAsset(page: pagingController.firstPageKey);
  }

  Future<void> queryCryptoAsset({
    required String query,
    bool readCache = true,
  }) async {
    try {
      emit(const CryptoAssetLoading());
      final assets = query.isNotEmpty
          ? await _marketplaceRepository.assetSearch(SearchAssetsRequest(
              page: 1,
              pageSize: 100,
              currency: 'USD', // todo: use correct fiat
              name: query, categories: [],
            ))
          : <Asset>[];
      emit(CryptoAssetLoaded(
          assets: assets.map((e) => e.toCryptoAsset()).toList()));
    } on Exception catch (e) {
      emit(CryptoAssetLoadedWithError(error: e));
    }
  }

  void _emitSafely(CryptoAssetState state) {
    if (_isDisposed) return;

    emit(state);
  }

  void dispose() {
    _isDisposed = true;
  }
}
