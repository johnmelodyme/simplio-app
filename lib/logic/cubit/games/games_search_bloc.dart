import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/logic/cubit/games/game_bloc_event.dart';
import 'package:simplio_app/logic/cubit/games/games_bloc.dart';
import 'package:simplio_app/view/themes/constants.dart';

class GamesSearchBloc extends GamesBloc {
  GamesSearchBloc({
    required UserRepository userRepository,
    required MarketplaceRepository marketplaceRepository,
  }) : super.builder(
            userRepository: userRepository,
            marketplaceRepository: marketplaceRepository) {
    on<SearchGamesEvent>(
      _onSearchGamesEvent,
      transformer: (events, mapper) {
        return events
            .debounceTime(Constants.searchDebounceDuration)
            .asyncExpand(mapper);
      },
    );
  }

  Future<void> _onSearchGamesEvent(
    SearchGamesEvent event,
    Emitter<GamesState> emit,
  ) async {
    if (event.criteria != currentlySearched) {
      currentlySearched = event.criteria;
      if (pagingController.itemList?.isNotEmpty == true) {
        add(const ReloadGamesEvent());
      } else {
        add(LoadGamesEvent(page: pagingController.firstPageKey));
      }
    }
  }
}
