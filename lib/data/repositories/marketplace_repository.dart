import 'package:simplio_app/data/http/services/marketplace_service.dart';

class MarketplaceRepository {
  final MarketplaceService _marketplaceService;

  MarketplaceRepository._(
    this._marketplaceService,
  );

  MarketplaceRepository.builder({
    required MarketplaceService marketplaceService,
  }) : this._(
          marketplaceService,
        );

  Future<List<Game>> gameSearch(SearchGamesRequest searchGamesRequest) async {
    final response = await _marketplaceService.gameSearch(searchGamesRequest);

    if (response.isSuccessful && response.body != null) {
      return response.body!.items;
    }

    throw Exception("Could not search games");
  }

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
}
