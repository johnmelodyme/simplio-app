import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:simplio_app/data/http/errors/bad_request_http_error.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/view/themes/constants.dart';

class MarketplaceRepository {
  final MarketplaceService _marketplaceService;
  final Map<int, List<Game>> _gamesPages = {};

  MarketplaceRepository._(
    this._marketplaceService,
  );

  MarketplaceRepository.builder({
    required MarketplaceService marketplaceService,
  }) : this._(marketplaceService);

  Future<List<Asset>> assetSearch(
      SearchAssetsRequest? searchAssetsRequest) async {
    final response = await _marketplaceService.assetSearch(
      searchAssetsRequest ??
          const SearchAssetsRequest(
            page: 1,
            pageSize: 10,
            currency: 'USD', // todo: use correct fiat
            name: '', categories: [],
          ),
    );

    if (response.isSuccessful && response.body != null) {
      return response.body!.items;
    }

    throw Exception("Could not search games");
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
  }) async {
    final response = await _marketplaceService.games(games.join(','), currency);

    if (response.isSuccessful && response.body != null) {
      return response.body!.items;
    }

    throw Exception("Could not search games");
  }

  Future<List<Game>> gameSearch(SearchGamesRequest searchGamesRequest) async {
    final response = await _marketplaceService.gameSearch(searchGamesRequest);

    if (response.isSuccessful && response.body != null) {
      _gamesPages[searchGamesRequest.page] = response.body!.items;
      return response.body!.items;
    }

    throw Exception("Could not search games");
  }

  Future<GameDetail> getGameDetail(String gameId, String currency) async {
    final response = await _marketplaceService.getGameDetail(gameId, currency);
    final gameDetail = response.body;
    if (response.isSuccessful && gameDetail != null) {
      return gameDetail;
    }

    throw Exception("Could not load game detail");
  }

  Future<SearchNftResponse> searchNft({
    required int page,
    required String currency,
    String name = '',
    List<int> categories = const [],
    String sort = '',
  }) async {
    try {
      final res = await _marketplaceService.searchNft(SearchNftBody(
        page: max(page, 1),
        pageSize: Constants.pageSizeGames,
        currency: currency,
        categories: categories,
        name: name,
        sort: sort,
      ));

      final body = res.body;
      if (res.isSuccessful && body != null) {
        return body;
      }

      if (res.statusCode == HttpStatus.badRequest) {
        throw BadRequestHttpError.fromObject(res.error);
      }

      throw Exception('Could not search nft: ${res.error}');
    } catch (e) {
      throw Exception('searching nft has failed');
    }
  }
}
