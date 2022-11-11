part of 'crypto_asset_cubit.dart';

abstract class CryptoAssetState extends Equatable {
  const CryptoAssetState();
}

class CryptoAssetInitial extends CryptoAssetState {
  @override
  List<Object?> get props => [];
}

class CryptoAssetLoading extends CryptoAssetState {
  @override
  List<Object?> get props => [];
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
