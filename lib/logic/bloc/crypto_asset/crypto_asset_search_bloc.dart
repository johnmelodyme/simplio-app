import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc_event.dart';
import 'package:simplio_app/view/themes/constants.dart';

class CryptoAssetSearchBloc extends CryptoAssetBloc {
  CryptoAssetSearchBloc.builder({
    required MarketplaceRepository marketplaceRepository,
  }) : super.builder(marketplaceRepository: marketplaceRepository) {
    on<SearchCryptoAssetsEvent>(_onSearchCryptoAssetsEvent,
        transformer: (events, mapper) {
      return events
          .debounceTime(Constants.searchDebounceDuration)
          .asyncExpand(mapper);
    });
  }

  void _onSearchCryptoAssetsEvent(
    SearchCryptoAssetsEvent event,
    Emitter<CryptoAssetState> emit,
  ) {
    if (event.criteria != currentlySearched) {
      currentlySearched = event.criteria;
      if (pagingController.itemList?.isNotEmpty == true) {
        add(const ReloadCryptoAssetsEvent());
      } else {
        add(LoadCryptoAssetsEvent(page: pagingController.firstPageKey));
      }
    }
  }
}
