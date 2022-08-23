import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'asset_service.chopper.dart';
part 'asset_service.g.dart';

@ChopperApi(baseUrl: '/assets')
abstract class AssetService extends ChopperService {
  static AssetService create() => _$AssetService();
  static FactoryConvertMap converter() => {
        AssetResponse: AssetResponse.fromJson,
      };

  @Get(path: '/system-assets')
  Future<Response<List<AssetResponse>>> system({
    @Query('crypto') required bool isCrypto,
    @Query('active') bool isActive = true,
    @Query('assets') List<String> selectedAssets = const [],
    @Query('networks') List<String> selectedNetworks = const [],
  });
}

@JsonSerializable()
class AssetResponse {
  final int networkId;
  final String? networkSymbol;
  final int assetId;
  final String name;
  final String ticker;
  final String? lowFee;
  final String? regularFee;
  final String? highFee;
  final String? gasLimit;
  final String? feeUnit;
  final int? decimalPlaces;
  final String? contractAddress;
  final bool isActive;
  final bool isFiat;

  const AssetResponse({
    required this.networkId,
    required this.networkSymbol,
    required this.assetId,
    required this.name,
    required this.ticker,
    this.lowFee,
    this.regularFee,
    this.highFee,
    this.gasLimit,
    this.feeUnit,
    this.decimalPlaces,
    this.contractAddress,
    required this.isActive,
    required this.isFiat,
  });

  factory AssetResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetResponseToJson(this);
}
