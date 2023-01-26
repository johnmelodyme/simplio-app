import 'dart:io';
import 'dart:math';
import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/data/http/errors/http_error.dart';

class MarketplaceApi extends HttpApi<MarketplaceService> {
  Future<List<Asset>> searchAsset(
    SearchAssetsRequest? searchAssetsRequest,
  ) async {
    final response = await service.assetSearch(
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

  Future<List<Game>> loadMyGames({
    required List<int> games,
    required String currency,
  }) async {
    final response = await service.games(games.join(','), currency);

    if (response.isSuccessful && response.body != null) {
      return response.body!.items;
    }

    throw Exception("Could not search games");
  }

  Future<List<Game>> searchGame(SearchGamesRequest searchGamesRequest) async {
    final response = await service.gameSearch(searchGamesRequest);

    if (response.isSuccessful && response.body != null) {
      return response.body!.items;
    }

    throw Exception("Could not search games");
  }

  Future<GameDetail> getGameDetail(String gameId, String currency) async {
    final response = await service.getGameDetail(gameId, currency);
    final gameDetail = response.body;
    if (response.isSuccessful && gameDetail != null) {
      return gameDetail;
    }

    throw Exception("Could not load game detail");
  }

  Future<SearchNftResponse> searchNft({
    required int page,
    required String currency,
    required String name,
    required List<int> categories,
    required String sort,
  }) async {
    try {
      final res = await service.searchNft(SearchNftBody(
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

      if (res.statusCode == HttpStatus.internalServerError) {
        throw InternalServerHttpError.fromObject(res.error);
      }

      throw const BadRequestHttpError();
    } on HttpError {
      rethrow;
    } catch (e) {
      throw const BadRequestHttpError(message: 'Searching nft has failed');
    }
  }
}
