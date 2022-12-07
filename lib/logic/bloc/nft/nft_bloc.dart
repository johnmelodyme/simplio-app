import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'nft_event.dart';
part 'nft_state.dart';

class NftBloc extends Bloc<NftEvent, NftState> {
  final MarketplaceRepository _marketplaceRepository;
  final PagingController<int, SearchNftItem> pagingController =
      PagingController(firstPageKey: 1);

  NftBloc.builder({
    required MarketplaceRepository marketplaceRepository,
  }) : this._(marketplaceRepository);

  NftBloc._(this._marketplaceRepository) : super(const NftInitial()) {
    on<NftRefreshed>(_onNftRefreshed);
    on<NftLoaded>(_onNftLoaded);
  }

  Future<void> _onNftRefreshed(
    NftRefreshed event,
    Emitter<NftState> emit,
  ) async {
    emit(const NftInitial());
  }

  Future<void> _onNftLoaded(
    NftLoaded event,
    Emitter<NftState> emit,
  ) async {
    emit(const NftLoadInProgress());

    try {
      final res = await _marketplaceRepository.searchNft(
        page: event.page,
        currency: event.currency,
      );

      emit(NftLoadSuccess(
        items: res.items,
        page: event.page,
      ));
    } on Exception catch (e) {
      emit(NftLoadFailure(e));
    }
  }
}
