import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/games_service.dart';
import 'package:simplio_app/data/repositories/games_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'games_state.dart';

class GamesCubit extends Cubit<GamesState> {
  final GamesRepository _gamesRepository;
  final PagingController<int, Game> pagingController =
      PagingController(firstPageKey: 1);

  bool _isDisposed = false;
  String _currentlySearched = '';

  GamesCubit._(
    this._gamesRepository,
  ) : super(GamesInitialState());

  GamesCubit.builder({
    required GamesRepository gamesRepository,
  }) : this._(gamesRepository);

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

  void loadGames(int pageKey) async {
    _emitSafely(GamesLoadingState());

    try {
      List<Game> games = await _gamesRepository.search(
        SearchGamesRequest(
          page: pageKey,
          pageSize: Constants.pageSizeGames,
          currency:
              'USD', //TODO.. specify currency and where it should comming from
          name: _currentlySearched,
        ),
      );

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

  void _emitSafely(GamesState gamesState) {
    if (_isDisposed) return;

    emit(gamesState);
  }

  void dispose() {
    _isDisposed = true;
  }
}
