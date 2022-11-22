import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';

class MyGamesBloc extends GamesBloc {
  MyGamesBloc({
    required UserRepository userRepository,
    required MarketplaceRepository marketplaceRepository,
  }) : super.builder(
            userRepository: userRepository,
            marketplaceRepository: marketplaceRepository) {
    on<LoadMyGamesEvent>(
      _onLoadMyGamesEvent,
    );
  }

  Future<void> _onLoadMyGamesEvent(
    LoadMyGamesEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());

    try {
      final userProfile = await userRepository.getAccountProfile();

      if (userProfile.gameLibrary?.isNotEmpty == true) {
        List<Game> games = await marketplaceRepository.loadMyGames(
          games: userProfile.gameLibrary ?? [],
          currency: 'USD',
        );

        emitSafely(emit, MyGamesLoadedState(games));
      } else {
        emitSafely(emit, const MyGamesLoadedState([]));
      }
    } catch (exception) {
      emitSafely(emit, GamesErrorState(exception.toString()));
    }
  }
}
