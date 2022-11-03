import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';

part 'marketplace_service.chopper.dart';
part 'marketplace_service.g.dart';

@ChopperApi(baseUrl: '/marketplace')
abstract class MarketplaceService extends ChopperService {
  static MarketplaceService create() => _$MarketplaceService();
  static FactoryConvertMap converter() => {
        GamesResponse: GamesResponse.fromJson,
        AssetsResponse: AssetsResponse.fromJson,
      };

  @Post(path: '/games/search')
  Future<Response<GamesResponse>> gameSearch(
    @Body() SearchGamesRequest body,
  );

  @Post(path: '/assets/search')
  Future<Response<AssetsResponse>> assetSearch(
    @Body() SearchAssetsRequest body,
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

@JsonSerializable()
class SearchAssetsRequest {
  final int page;
  final int pageSize;
  final String currency;
  final String name;
  final List<int> categories;
  final SortType sort;

  const SearchAssetsRequest({
    required this.page,
    required this.pageSize,
    required this.currency,
    required this.name,
    required this.categories,
    this.sort = SortType.desc,
  });

  factory SearchAssetsRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchAssetsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAssetsRequestToJson(this);
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
class AssetsResponse {
  final List<Asset> items;
  final int totalCount;

  const AssetsResponse({
    required this.items,
    required this.totalCount,
  });

  factory AssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);
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
class Network {
  final int networkId;
  final String networkTicker;
  final int decimalPlaces;
  final String? contractAddress;

  const Network({
    required this.networkId,
    required this.networkTicker,
    required this.decimalPlaces,
    required this.contractAddress,
  });

  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkToJson(this);

  NetworkData toNetworkData(int assetId) => NetworkData(
        networkId: networkId,
        assetId: assetId,
        networkTicker: networkTicker,
      );
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

@JsonSerializable()
class Asset {
  final int assetId;
  final String name;
  final String ticker;
  final bool isPromoted;
  final String currency;
  final double price;
  final List<Network> networks;

  const Asset({
    required this.assetId,
    required this.name,
    required this.ticker,
    required this.isPromoted,
    required this.currency,
    required this.price,
    required this.networks,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  CryptoAssetData toCryptoAsset() => CryptoAssetData(
        assetId: assetId,
        name: name,
        ticker: ticker,
        price: price,
        networks: networks.map((e) => e.toNetworkData(assetId)).toSet(),
      );
}
