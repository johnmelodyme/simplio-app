import 'package:collection/collection.dart';
import 'package:simplio_app/data/http/apis/marketplace_api.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';

class MarketplaceRepository {
  final MarketplaceApi _marketplaceApi;
  final Map<int, List<Game>> _gamesPages = {};

  MarketplaceRepository._(
    this._marketplaceApi,
  );

  MarketplaceRepository({
    required MarketplaceApi marketplaceApi,
  }) : this._(marketplaceApi);

  Future<List<Asset>> assetSearch(
    SearchAssetsRequest? searchAssetsRequest,
  ) {
    return _marketplaceApi.searchAsset(searchAssetsRequest);
  }

  Game getGameById(int gameId) {
    for (final List<Game> games in _gamesPages.values) {
      Game? game = games.firstWhereOrNull((game) => game.gameId == gameId);
      if (game != null) {
        return game;
      }
    }
    throw Exception("Could not find game");
  }

  // TODO - rethink domain ownership
  Future<List<Game>> loadMyGames({
    required List<int> games,
    required String currency,
  }) {
    return _marketplaceApi.loadMyGames(games: games, currency: currency);
  }

  Future<List<Game>> searchGame(
    SearchGamesRequest searchGamesRequest,
  ) async {
    final res = await _marketplaceApi.searchGame(searchGamesRequest);
    _gamesPages[searchGamesRequest.page] = res;

    return res;
  }

  Future<GameDetail> getGameDetail(
    String gameId,
    String currency,
  ) {
    return _marketplaceApi.getGameDetail(gameId, currency);
  }

  Future<SearchNftResponse> searchNft({
    required int page,
    required String currency,
    String name = '',
    List<int> categories = const [],
    String sort = '',
  }) {
    return _marketplaceApi.searchNft(
      page: page,
      currency: currency,
      name: name,
      categories: categories,
      sort: sort,
    );
  }
}
