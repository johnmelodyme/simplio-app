import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'games_state.dart';

class GamesBloc extends Bloc<GameBlocEvent, GamesState> {
  final UserRepository userRepository;
  final MarketplaceRepository marketplaceRepository;
  final PagingController<int, Game> pagingController =
      PagingController(firstPageKey: 1);

  String currentlySearched = '';

  GamesBloc.builder({
    required UserRepository userRepository,
    required MarketplaceRepository marketplaceRepository,
  }) : this._(userRepository, marketplaceRepository);

  GamesBloc._(
    this.userRepository,
    this.marketplaceRepository,
  ) : super(GamesInitialState()) {
    on<LoadGamesEvent>(_onLoadGamesEvent);
    on<ReloadGamesEvent>(_onReloadGamesEvent);
    on<LoadGameEvent>(_onLoadGameEvent);
    on<CheckIfGameIsAddedEvent>(_onCheckIfGameIsAddedEvent);
    on<AddGameToLibraryEvent>(_onAddGameToLibraryEvent);
    on<RemoveGameFromLibraryEvent>(_onRemoveGameFromLibraryEvent);
  }

  Game getGameById(int gameId) => marketplaceRepository.getGameById(gameId);

  Future<void> _onLoadGamesEvent(
    LoadGamesEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());

    try {
      List<Game> games = await marketplaceRepository.searchGame(
        SearchGamesRequest(
          page: event.page,
          pageSize: Constants.pageSizeGames,
          currency:
              'USD', //TODO.. specify currency and where it should comming from
          name: currentlySearched,
        ),
      );

      final userProfile = await userRepository.getAccountProfile();
      if (userProfile.gameLibrary?.isNotEmpty == true) {
        for (final game in games) {
          game.isAdded = userProfile.gameLibrary!.contains(game.gameId);
        }
      }

      if (games.length < Constants.pageSizeGames) {
        pagingController.appendLastPage(games);
      } else {
        pagingController.appendPage(games, event.page + 1);
      }

      emitSafely(emit, const GamesLoadedState());
    } catch (exception) {
      pagingController.error = exception.toString();
      emitSafely(emit, GamesErrorState(exception.toString()));
    }
  }

  Future<void> _onReloadGamesEvent(
    ReloadGamesEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());
    pagingController.refresh();
    emitSafely(emit, GamesInitialState());
  }

  Future<void> _onLoadGameEvent(
    LoadGameEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());
    try {
      final gameDetail =
          await marketplaceRepository.getGameDetail(event.gameId, 'USD');

      emitSafely(
        emit,
        GameDetailLoadedState(
          gameDetail: gameDetail,
        ),
      );
    } catch (exception) {
      pagingController.error = exception.toString();
      emitSafely(emit, GamesErrorState(exception.toString()));
    }
  }

  Future<void> _onCheckIfGameIsAddedEvent(
    CheckIfGameIsAddedEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());
    final isAdded = await userRepository.gameIsAdded(event.gameId);
    emitSafely(emit, GameDetailIsAddedState(isAdded: isAdded));
  }

  Future<void> _onAddGameToLibraryEvent(
    AddGameToLibraryEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());
    final isAdded = await userRepository.addGameToLibrary(event.gameId);
    emitSafely(
        emit, GameDetailIsAddedState(isAdded: isAdded, wasUpdated: true));

    if (event.reload) {
      add(const ReloadGamesEvent());
    }
  }

  Future<void> _onRemoveGameFromLibraryEvent(
    RemoveGameFromLibraryEvent event,
    Emitter<GamesState> emit,
  ) async {
    emitSafely(emit, GamesLoadingState());
    final isAdded = await userRepository.removeGameFromLibrary(event.gameId);
    emitSafely(
        emit, GameDetailIsAddedState(isAdded: isAdded, wasUpdated: true));

    if (event.reload) {
      add(const ReloadGamesEvent());
    }
  }

  void emitSafely(Emitter emit, GamesState gamesState) {
    if (!isClosed) {
      emit(gamesState);
    }
  }
}
