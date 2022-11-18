import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_bloc_event.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'crypto_asset_state.dart';

class CryptoAssetBloc extends Bloc<CryptoAssetBlocEvent, CryptoAssetState> {
  final MarketplaceRepository _marketplaceRepository;
  final PagingController<int, Asset> pagingController =
      PagingController(firstPageKey: 1);

  String currentlySearched = '';

  CryptoAssetBloc.builder({
    required MarketplaceRepository marketplaceRepository,
  }) : this._(marketplaceRepository);

  CryptoAssetBloc._(this._marketplaceRepository) : super(CryptoAssetInitial()) {
    on<LoadCryptoAssetsEvent>(_onLoadCryptoAssets);
    on<ReloadCryptoAssetsEvent>(_onReloadCryptoAssets);
  }

  Future<void> _onLoadCryptoAssets(
    LoadCryptoAssetsEvent event,
    Emitter<CryptoAssetState> emit,
  ) async {
    _emitSafely(emit, CryptoAssetLoading());
    try {
      final assets = await _marketplaceRepository.assetSearch(
        SearchAssetsRequest(
          page: event.page,
          pageSize: Constants.pageSizeAssets,
          currency: 'USD', // todo: use correct fiat
          name: currentlySearched,
          categories: [],
        ),
      );

      if (assets.length < Constants.pageSizeAssets) {
        pagingController.appendLastPage(assets);
      } else {
        pagingController.appendPage(assets, event.page + 1);
      }

      _emitSafely(
        emit,
        CryptoAssetLoaded(
            assets: assets.map((e) => e.toCryptoAsset()).toList()),
      );
    } on Exception catch (e) {
      _emitSafely(emit, CryptoAssetLoadedWithError(error: e));
    }
  }

  void _onReloadCryptoAssets(
    ReloadCryptoAssetsEvent event,
    Emitter<CryptoAssetState> emit,
  ) {
    _emitSafely(emit, CryptoAssetLoading());
    pagingController.refresh();
    _emitSafely(emit, CryptoAssetInitial());
  }

  void _emitSafely(Emitter emit, CryptoAssetState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
