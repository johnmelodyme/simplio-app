part of 'crypto_asset_cubit.dart';

abstract class CryptoAssetState extends Equatable {
  const CryptoAssetState();

  @override
  List<Object?> get props => [];
}

class CryptoAssetInitial extends CryptoAssetState {
  const CryptoAssetInitial();
}

class CryptoAssetLoading extends CryptoAssetState {
  const CryptoAssetLoading();
}

class CryptoAssetLoaded extends CryptoAssetState {
  final List<CryptoAssetData> assets;

  const CryptoAssetLoaded({
    required this.assets,
  });

  @override
  List<Object?> get props => [assets];
}

class CryptoAssetLoadedWithError extends CryptoAssetState {
  final Exception error;

  const CryptoAssetLoadedWithError({required this.error});

  @override
  List<Object?> get props => [error];
}
