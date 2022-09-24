import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';

part 'crypto_asset_state.dart';

class CryptoAssetCubit extends Cubit<CryptoAssetState> {
  final AssetRepository _assetRepository;

  CryptoAssetCubit._(
    this._assetRepository,
  ) : super(const CryptoAssetInitial());

  CryptoAssetCubit.builder({
    required AssetRepository assetRepository,
  }) : this._(assetRepository);

  Future<void> loadCryptoAsset({bool cache = true}) async {
    emit(const CryptoAssetLoading());

    try {
      final assets = await _assetRepository.loadCryptoAssets(cache: cache);
      emit(CryptoAssetLoaded(assets: assets));
    } on Exception catch (e) {
      emit(CryptoAssetLoadedWithError(error: e));
    }
  }

  Future<void> queryCryptoAsset({
    required String query,
    bool cache = true,
  }) async {
    try {
      final assets = await _assetRepository.loadCryptoAssets(cache: cache).then(
            (loadedAssets) => loadedAssets
                .where((d) =>
                    d.name.toLowerCase().contains(query.toLowerCase()) ||
                    d.ticker.toLowerCase().contains(query.toLowerCase()))
                .toList(),
          );
      emit(CryptoAssetLoaded(assets: assets));
    } on Exception catch (e) {
      emit(CryptoAssetLoadedWithError(error: e));
    }
  }
}
