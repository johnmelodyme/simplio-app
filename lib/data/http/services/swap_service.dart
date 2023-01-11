import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'swap_service.chopper.dart';
part 'swap_service.g.dart';

@ChopperApi(baseUrl: '/swap')
abstract class SwapService extends ChopperService {
  static SwapService create() => _$SwapService();
  static FactoryConvertMap converter() => {
        SwapRouteResponse: SwapRouteResponse.fromJson,
        SwapParametersResponse: SwapParametersResponse.fromJson,
      };

  @Get(path: '/routes')
  Future<Response<List<SwapRouteResponse>>> getAvailableRoutes(
      [@Query('currency') String? assetTicker]);

  @Get(path: '/params')
  Future<Response<SwapParametersResponse>> getSwapParameters({
    @Query() required String sourceAmount,
    @Query() required String sourceAssetId,
    @Query('sourceAssetNetworkId') required String sourceNetworkId,
    @Query() required String targetAssetId,
    @Query('targetAssetNetworkId') required String targetNetworkId,
  });

  @Post(path: '/start-single')
  Future<Response<bool>> startSingleSwap(
    @Body() SingleSwapBody body,
  );
}

@JsonSerializable()
class SwapRouteResponse {
  final CryptoAsset sourceAsset;
  final CryptoAsset targetAsset;
  final String sourceDepositAddress;

  const SwapRouteResponse({
    required this.sourceAsset,
    required this.targetAsset,
    required this.sourceDepositAddress,
  });

  factory SwapRouteResponse.fromJson(Map<String, dynamic> json) =>
      _$SwapRouteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwapRouteResponseToJson(this);
}

@JsonSerializable()
class SwapParametersResponse {
  final BigInt sourceMinDepositAmount;
  final BigInt targetGuaranteedWithdrawalAmount;
  final BigInt totalSwapFee;
  final double totalSwapFeeFiat;
  final BigInt sourceTransactionFee;
  final double sourceTransactionFeeFiat;
  final BigInt targetTransactionFee;
  final double targetTransactionFeeFiat;
  final BigInt swapFee;
  final double swapFeeFiat;
  final double sourceNetworkCoinFiatRatio;
  final bool hasAllowance;

  SwapParametersResponse({
    required this.sourceMinDepositAmount,
    required this.targetGuaranteedWithdrawalAmount,
    required this.totalSwapFee,
    required this.totalSwapFeeFiat,
    required this.sourceTransactionFee,
    required this.sourceTransactionFeeFiat,
    required this.targetTransactionFee,
    required this.targetTransactionFeeFiat,
    required this.swapFee,
    required this.swapFeeFiat,
    required this.sourceNetworkCoinFiatRatio,
    required this.hasAllowance,
  });

  factory SwapParametersResponse.fromJson(Map<String, dynamic> json) =>
      _$SwapParametersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwapParametersResponseToJson(this);
}

@JsonSerializable()
class SingleSwapBody {
  final String sourceTxId;
  final String targetAddress;
  final String refundAddress;
  late BigInt targetPrice;
  late BigInt sourceInitialAmount;
  final BigInt userAgreedAmount;
  late BigInt sourceTxFee;
  late BigInt sourceInitialAmountInFiat;
  late BigInt targetInitialAmountInFiat;
  late BigInt usdToEurRate;
  final CryptoAsset sourceAsset;
  final CryptoAsset targetAsset;
  final int slippage;

  SingleSwapBody({
    required this.sourceTxId,
    required this.targetAddress,
    required this.refundAddress,
    required this.userAgreedAmount,
    required this.sourceAsset,
    required this.targetAsset,
    required this.slippage,
  }) {
    targetPrice = BigInt.from(1);
    sourceInitialAmount = BigInt.from(1);
    sourceTxFee = BigInt.from(1);
    sourceInitialAmountInFiat = BigInt.from(1);
    targetInitialAmountInFiat = BigInt.from(1);
    usdToEurRate = BigInt.from(1);
  }

  factory SingleSwapBody.fromJson(Map<String, dynamic> json) =>
      _$SingleSwapBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SingleSwapBodyToJson(this);
}

@JsonSerializable()
class CryptoAsset {
  final int assetId;
  final int networkId;
  final double price;

  const CryptoAsset({
    required this.assetId,
    required this.networkId,
    required this.price,
  });

  factory CryptoAsset.fromJson(Map<String, dynamic> json) =>
      _$CryptoAssetFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoAssetToJson(this);
}
