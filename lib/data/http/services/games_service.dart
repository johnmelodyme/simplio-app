import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'games_service.chopper.dart';
part 'games_service.g.dart';

@ChopperApi(baseUrl: '/marketplace')
abstract class GamesService extends ChopperService {
  static GamesService create() => _$GamesService();
  static FactoryConvertMap converter() => {
        GamesResponse: GamesResponse.fromJson,
      };

  @Post(path: '/games/search')
  Future<Response<GamesResponse>> search(
    @Body() SearchGamesRequest body,
  );
}

@JsonSerializable()
class SearchGamesRequest {
  final int page;
  final int pageSize;
  final String currency;
  final String name;
  final List<int> networks;
  final List<int> releases;
  final List<int> genres;
  final List<int> categories;
  final SortType sort;
  final bool omit;

  const SearchGamesRequest({
    required this.page,
    required this.pageSize,
    required this.currency,
    required this.name,
    this.networks = const [],
    this.releases = const [],
    this.genres = const [],
    this.categories = const [],
    this.sort = SortType.trending,
    this.omit = false,
  });

  factory SearchGamesRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchGamesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchGamesRequestToJson(this);
}

enum Release { alpha, beta, live, playToEarn, preSale }

enum Genre { action, adventure, arcade }

enum Category { airdrops, freeToPlay, nftIncluded, playToEarn }

enum SortType { trending, latest, desc }

@JsonSerializable()
class GamesResponse {
  final List<Game> items;
  final int totalCount;

  const GamesResponse({
    required this.items,
    required this.totalCount,
  });

  factory GamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GamesResponseToJson(this);
}

@JsonSerializable()
class Game {
  final String preview;
  final int gameId;
  final String name;
  final AssetEmbedded assetEmbedded;
  final bool isPromoted;
  final int category;
  final String platform;
  final String playUri;

  const Game({
    required this.preview,
    required this.gameId,
    required this.name,
    required this.assetEmbedded,
    required this.isPromoted,
    required this.category,
    required this.platform,
    required this.playUri,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);
}

@JsonSerializable()
class AssetEmbedded {
  final int assetId;
  final int networkId;
  final int decimalPlaces;
  final String? contractAddress;
  final double price; //TODO.. should be int
  final String currency;

  const AssetEmbedded({
    required this.assetId,
    required this.networkId,
    required this.decimalPlaces,
    required this.contractAddress,
    required this.price,
    required this.currency,
  });

  factory AssetEmbedded.fromJson(Map<String, dynamic> json) =>
      _$AssetEmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$AssetEmbeddedToJson(this);
}
