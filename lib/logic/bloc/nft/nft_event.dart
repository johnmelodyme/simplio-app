part of 'nft_bloc.dart';

abstract class NftEvent extends Equatable {
  const NftEvent();

  @override
  List<Object?> get props => [];
}

class NftRefreshed extends NftEvent {
  const NftRefreshed();
}

class NftLoaded extends NftEvent {
  final int page;
  final String currency;

  const NftLoaded({
    this.page = 1,
    this.currency = 'USD',
  });

  @override
  List<Object?> get props => [page, currency];
}
