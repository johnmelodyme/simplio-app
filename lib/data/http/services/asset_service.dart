import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'asset_service.chopper.dart';
part 'asset_service.g.dart';

@ChopperApi(baseUrl: '/assets')
abstract class AssetService extends ChopperService {
  static AssetService create() => _$AssetService();
  static FactoryConvertMap converter() => {
        CryptoAssetResponse: CryptoAssetResponse.fromJson,
        FiatAssetResponse: FiatAssetResponse.fromJson,
      };

  @Get(path: '/system-assets')
  Future<Response<List<CryptoAssetResponse>>> crypto({
    @Query('crypto') bool? isCrypto = true,
    @Query('active') bool isActive = true,
    @Query('assets') List<String> selectedAssets = const [],
    @Query('networks') List<String> selectedNetworks = const [],
  });

  @Get(path: '/system-assets')
  Future<Response<List<FiatAssetResponse>>> fiat({
    @Query('crypto') bool? isCrypto = false,
    @Query('active') bool isActive = true,
    @Query('assets') List<String> selectedAssets = const [],
    @Query('networks') List<String> selectedNetworks = const [],
  });
}

@JsonSerializable()
class CryptoAssetResponse {
  final int assetId;
  final String ticker;
  final int networkId;
  final String networkTicker;
  final String name;
  final String lowFee;
  final String regularFee;
  final String highFee;
  final String gasLimit;
  final String? feeUnit;
  final int decimalPlaces;
  final String? contractAddress;
  final bool isActive;

  const CryptoAssetResponse({
    required this.assetId,
    required this.ticker,
    required this.networkId,
    required this.networkTicker,
    required this.name,
    required this.lowFee,
    required this.regularFee,
    required this.highFee,
    required this.gasLimit,
    required this.feeUnit,
    required this.decimalPlaces,
    this.contractAddress,
    required this.isActive,
  });

  factory CryptoAssetResponse.fromJson(Map<String, dynamic> json) =>
      _$CryptoAssetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoAssetResponseToJson(this);
}

@JsonSerializable()
class FiatAssetResponse {
  final String assetId;
  final String ticker;
  final int networkId;
  final String name;
  final bool isActive;

  const FiatAssetResponse({
    required this.assetId,
    required this.ticker,
    required this.networkId,
    required this.name,
    required this.isActive,
  });

  factory FiatAssetResponse.fromJson(Map<String, dynamic> json) =>
      _$FiatAssetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FiatAssetResponseToJson(this);
}
