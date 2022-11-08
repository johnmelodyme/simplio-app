import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'games_state.dart';

class GamesCubit extends Cubit<GamesState> {
  final UserRepository _userRepository;
  final MarketplaceRepository _marketplaceRepository;
  final PagingController<int, Game> pagingController =
      PagingController(firstPageKey: 1);

  bool _isDisposed = false;
  String _currentlySearched = '';

  GamesCubit._(
    this._userRepository,
    this._marketplaceRepository,
  ) : super(GamesInitialState());

  GamesCubit.builder({
    required UserRepository userRepository,
    required MarketplaceRepository marketplaceRepository,
  }) : this._(userRepository, marketplaceRepository);

  void reloadGames() {
    _emitSafely(GamesLoadingState());
    pagingController.refresh();
    _emitSafely(GamesInitialState());
  }

  void search(String criteria) async {
    if (criteria != _currentlySearched) {
      _currentlySearched = criteria;
      if (pagingController.itemList?.isNotEmpty == true) {
        reloadGames();
      } else {
        loadGames(pagingController.firstPageKey);
      }
    }
  }

  void loadMyGames() async {
    _emitSafely(GamesLoadingState());

    try {
      final userProfile = await _userRepository.getAccountProfile();

      if (userProfile.gameLibrary?.isNotEmpty == true) {
        List<Game> games = await _marketplaceRepository.loadMyGames(
          games: userProfile.gameLibrary ?? [],
          currency: 'USD',
        );

        _emitSafely(MyGamesLoadedState(games));
      } else {
        _emitSafely(const MyGamesLoadedState([]));
      }
    } catch (exception) {
      pagingController.error = exception.toString();
      _emitSafely(GamesErrorState(exception.toString()));
    }
  }

  void loadGames(int pageKey) async {
    _emitSafely(GamesLoadingState());

    try {
      List<Game> games = await _marketplaceRepository.gameSearch(
        SearchGamesRequest(
          page: pageKey,
          pageSize: Constants.pageSizeGames,
          currency:
              'USD', //TODO.. specify currency and where it should comming from
          name: _currentlySearched,
        ),
      );

      final userProfile = await _userRepository.getAccountProfile();
      if (userProfile.gameLibrary?.isNotEmpty == true) {
        for (final game in games) {
          game.isAdded = userProfile.gameLibrary!.contains(game.gameId);
        }
      }

      if (games.length < Constants.pageSizeGames) {
        pagingController.appendLastPage(games);
      } else {
        pagingController.appendPage(games, pageKey + 1);
      }

      _emitSafely(const GamesLoadedState());
    } catch (exception) {
      pagingController.error = exception.toString();
      _emitSafely(GamesErrorState(exception.toString()));
    }
  }

  Game getGameById(int gameId) => _marketplaceRepository.getGameById(gameId);

  Future<void> loadGame(String gameId) async {
    _emitSafely(GamesLoadingState());
    try {
      final gameDetail =
          await _marketplaceRepository.getGameDetail(gameId, 'USD');

      _emitSafely(
        GameDetailLoadedState(
          gameDetail: gameDetail,
        ),
      );
    } catch (exception) {
      pagingController.error = exception.toString();
      _emitSafely(GamesErrorState(exception.toString()));
    }
  }

  Future<void> checkIfIsAdded(int gameId) async {
    _emitSafely(GamesLoadingState());
    final isAdded = await _userRepository.gameIsAdded(gameId);
    _emitSafely(GameDetailIsAddedState(isAdded: isAdded));
  }

  Future<void> addGameToLibrary(int gameId, {bool reload = false}) async {
    _emitSafely(GamesLoadingState());
    final isAdded = await _userRepository.addGameToLibrary(gameId);
    _emitSafely(GameDetailIsAddedState(isAdded: isAdded, wasUpdated: true));

    if (reload) {
      reloadGames();
    }
  }

  Future<void> removeGameFromLibrary(int gameId, {reload = false}) async {
    _emitSafely(GamesLoadingState());
    final isAdded = await _userRepository.removeGameFromLibrary(gameId);
    _emitSafely(GameDetailIsAddedState(isAdded: isAdded, wasUpdated: true));

    if (reload) {
      reloadGames();
    }
  }

  void _emitSafely(GamesState gamesState) {
    if (_isDisposed) return;
    emit(gamesState);
  }

  void dispose() {
    _isDisposed = true;
  }
}
