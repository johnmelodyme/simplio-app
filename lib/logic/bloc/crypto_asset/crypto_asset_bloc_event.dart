import 'package:equatable/equatable.dart';

abstract class CryptoAssetBlocEvent extends Equatable {
  const CryptoAssetBlocEvent();
}

class LoadCryptoAssetsEvent extends CryptoAssetBlocEvent {
  final int page;

  const LoadCryptoAssetsEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class ReloadCryptoAssetsEvent extends CryptoAssetBlocEvent {
  const ReloadCryptoAssetsEvent();

  @override
  List<Object?> get props => [];
}

class SearchCryptoAssetsEvent extends CryptoAssetBlocEvent {
  final String criteria;
  const SearchCryptoAssetsEvent(this.criteria);

  @override
  List<Object?> get props => [criteria];
}
