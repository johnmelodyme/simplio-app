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
        GameDetail: GameDetail.fromJson,
        SearchNftBody: SearchNftBody.fromJson,
        SearchNftResponse: SearchNftResponse.fromJson,
        SearchNftItem: SearchNftItem.fromJson,
      };

  @Post(path: '/assets/search')
  Future<Response<AssetsResponse>> assetSearch(
    @Body() SearchAssetsRequest body,
  );

  @Get(path: '/games')
  Future<Response<GamesResponse>> games(
    @Query('games') String gameIds,
    @Query('currency') String currency,
  );

  @Post(path: '/games/search')
  Future<Response<GamesResponse>> gameSearch(
    @Body() SearchGamesRequest body,
  );

  @Get(path: '/games/detail')
  Future<Response<GameDetail>> getGameDetail(
    @Query('gameId') String gameId,
    @Query('currency') String currency,
  );

  @Post(path: '/nfts/search')
  Future<Response<SearchNftResponse>> searchNft(
    @Body() SearchNftBody body,
  );
}

@JsonSerializable()
class SearchNftBody {
  final int page;
  final int pageSize;
  final String currency;
  final String name;
  final String sort;
  final List<int> categories;

  const SearchNftBody({
    required this.page,
    required this.pageSize,
    required this.currency,
    this.name = '',
    this.sort = '',
    this.categories = const [],
  });

  factory SearchNftBody.fromJson(Map<String, dynamic> json) =>
      _$SearchNftBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SearchNftBodyToJson(this);
}

@JsonSerializable()
class SearchNftResponse {
  final List<SearchNftItem> items;
  final int totalCount;

  const SearchNftResponse({
    this.items = const [],
    required this.totalCount,
  });

  factory SearchNftResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchNftResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchNftResponseToJson(this);
}

@JsonSerializable()
class SearchNftItem {
  final int nftId;
  final String name;
  final String game;
  final bool isPromoted;
  final int category;
  final PreviewResolution preview;
  final double price;
  final String currency;
  final AssetEmbedded asset;

  const SearchNftItem({
    required this.nftId,
    required this.name,
    required this.game,
    required this.isPromoted,
    required this.category,
    required this.preview,
    required this.price,
    required this.currency,
    required this.asset,
  });

  factory SearchNftItem.fromJson(Map<String, dynamic> json) =>
      _$SearchNftItemFromJson(json);

  Map<String, dynamic> toJson() => _$SearchNftItemToJson(this);
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
class PreviewResolution {
  final String low;
  final String high;

  const PreviewResolution({
    required this.low,
    required this.high,
  });

  factory PreviewResolution.fromJson(Map<String, dynamic> json) =>
      _$PreviewResolutionFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewResolutionToJson(this);
}

@JsonSerializable()
class Game {
  final PreviewResolution preview;
  final int gameId;
  final String name;
  final AssetEmbedded assetEmbedded;
  final bool isPromoted;
  final int category;
  final String platform;
  final String playUri;

  @JsonKey(ignore: true)
  bool isAdded;

  Game({
    required this.preview,
    required this.gameId,
    required this.name,
    required this.assetEmbedded,
    required this.isPromoted,
    required this.category,
    required this.platform,
    required this.playUri,
    this.isAdded = false,
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

@JsonSerializable()
class GameDetail {
  int gameId;
  String name;
  int genre;
  int release;
  List<PreviewResolution> preview;
  List<String> caption;
  List<Reference> references;
  AssetEmbedded assetEmbedded;
  bool isPromoted;
  int category;
  GamePlatform platform;
  String playUri;
  String color;

  GameDetail({
    required this.gameId,
    required this.name,
    required this.genre,
    required this.release,
    required this.preview,
    required this.caption,
    required this.references,
    required this.assetEmbedded,
    required this.isPromoted,
    required this.category,
    required this.platform,
    required this.playUri,
    required this.color,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) =>
      _$GameDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GameDetailToJson(this);
}

@JsonSerializable()
class Reference {
  @JsonKey(name: 'reference')
  ReferenceType referenceType;
  String name;
  String url;

  Reference({
    required this.referenceType,
    required this.name,
    required this.url,
  });

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}

enum ReferenceType {
  @JsonValue("WEB")
  web,
  @JsonValue("DISCORD")
  discord,
  @JsonValue("TWITTER")
  twitter,
  @JsonValue("TELEGRAM")
  telegram,
  @JsonValue("INSTAGRAM")
  instagram,
  @JsonValue("YOUTUBE")
  youtube,
  @JsonValue("MEDIUM")
  medium,
}

enum GamePlatform {
  @JsonValue("MOBILE")
  mobile,
  @JsonValue("DESKTOP")
  desktop,
  @JsonValue("WEB")
  web,
}
