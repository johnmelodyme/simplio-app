part of 'nft_bloc.dart';

abstract class NftState extends Equatable {
  const NftState();

  @override
  List<Object?> get props => [];
}

class NftInitial extends NftState {
  const NftInitial();
}

class NftLoadInProgress extends NftState {
  const NftLoadInProgress();
}

class NftLoadSuccess extends NftState {
  final int page;
  final List<SearchNftItem> items;

  const NftLoadSuccess({
    required this.page,
    required this.items,
  });

  int get nextPage => page + 1;

  bool get isLastPage => items.length < Constants.pageSizeGames;

  @override
  List<Object?> get props => [page, items];
}

class NftLoadFailure extends NftState {
  final Exception error;

  const NftLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
