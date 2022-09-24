import 'package:simplio_app/data/http/services/games_service.dart';

class GamesRepository {
  final GamesService _gamesService;

  GamesRepository._(this._gamesService);

  GamesRepository.builder({
    required GamesService gamesService,
  }) : this._(
          gamesService,
        );

  Future<List<Game>> search(SearchGamesRequest searchGamesRequest) async {
    final response = await _gamesService.search(searchGamesRequest);

    if (response.isSuccessful && response.body != null) {
      return response.body!.items;
    }

    throw Exception("Could not search games");
  }
}
