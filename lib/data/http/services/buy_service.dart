import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'buy_service.chopper.dart';
part 'buy_service.g.dart';

@ChopperApi(baseUrl: '/debit-card')
abstract class BuyService extends ChopperService {
  static BuyService create() => _$BuyService();
  static FactoryConvertMap converter() => {
        BuyConvertBodyForFiat: BuyConvertBodyForFiat.fromJson,
        ConvertFiatAsset: ConvertFiatAsset.fromJson,
        ConvertCryptoAsset: ConvertCryptoAsset.fromJson,
        BuyOrderBody: BuyOrderBody.fromJson,
        BuyPairResponse: BuyPairResponse.fromJson,
        PairFiatAsset: PairFiatAsset.fromJson,
        PairCryptoAsset: PairCryptoAsset.fromJson,
        BuyConvertResponse: BuyConvertResponse.fromJson,
        FiatAsset: FeeAsset.fromJson,
        CryptoAsset: CryptoAsset.fromJson,
        FeeAsset: FeeAsset.fromJson,
        BuyOrderResponse: BuyOrderResponse.fromJson,
        BuyHistoryResponseItem: BuyHistoryResponseItem.fromJson,
        CurrencyItem: CurrencyItem.fromJson,
        StatusResponse: StatusResponse.fromJson,
      };

  @Get(path: '/pairs')
  Future<Response<BuyPairResponse>> pairs();

  @Get(path: '/orders/history')
  Future<Response<List<BuyHistoryResponseItem>>> history();

  @Post(path: '/orders/initialize')
  Future<Response<BuyOrderResponse>> initialize(
    @Body() BuyOrderBody body,
  );

  @Get(path: '/orders/status')
  Future<Response<StatusResponse>> status(
    @Query('orderId') String orderId,
  );

  @Delete(path: '/orders/cancel')
  Future<void> cancel();

  @Post(path: '/orders/convert')
  Future<Response<BuyConvertResponse>> convertForFiat(
    @Body() BuyConvertBodyForFiat body,
  );

  @Post(path: '/orders/convert')
  Future<Response<BuyConvertResponse>> convertForCrypto(
    @Body() BuyConvertBodyForCrypto body,
  );
}

@JsonSerializable()
class BuyOrderResponse {
  final String orderId;
  final DateTime createdAt;
  final String? uid;
  final String status;
  final String? origin;
  final String paymentUrl;
  final ConvertFiatAsset fiatAsset;
  final ConvertCryptoAsset cryptoAsset;

  BuyOrderResponse({
    required this.orderId,
    required this.createdAt,
    this.uid,
    required this.status,
    this.origin,
    required this.paymentUrl,
    required this.fiatAsset,
    required this.cryptoAsset,
  });

  factory BuyOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$BuyOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BuyOrderResponseToJson(this);
}

@JsonSerializable()
class BuyPairResponse {
  final List<BuyPairResponseItem> items;

  BuyPairResponse({required this.items});

  factory BuyPairResponse.fromJson(Map<String, dynamic> json) =>
      _$BuyPairResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BuyPairResponseToJson(this);
}

@JsonSerializable()
class BuyPairResponseItem {
  final PairFiatAsset fiatAsset;
  final PairCryptoAsset cryptoAsset;

  BuyPairResponseItem({
    required this.fiatAsset,
    required this.cryptoAsset,
  });

  factory BuyPairResponseItem.fromJson(Map<String, dynamic> json) =>
      _$BuyPairResponseItemFromJson(json);

  Map<String, dynamic> toJson() => _$BuyPairResponseItemToJson(this);
}

@JsonSerializable()
class StatusResponse {
  final String status;
  final bool isCompleted;

  StatusResponse({
    required this.status,
    required this.isCompleted,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusResponseToJson(this);
}

@JsonSerializable()
class CurrencyItem {
  final String currency;
  final double amount;

  CurrencyItem({
    required this.currency,
    required this.amount,
  });

  factory CurrencyItem.fromJson(json) => _$CurrencyItemFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyItemToJson(this);
}

@JsonSerializable()
class BuyHistoryResponseItem {
  final String userId;
  final String orderId;
  final String status;
  final String provider;
  final String providerOrderId;
  final CurrencyItem from;
  final CurrencyItem to;
  final CurrencyItem fee;
  final CurrencyItem merchantFee;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  BuyHistoryResponseItem({
    required this.userId,
    required this.orderId,
    required this.status,
    required this.provider,
    required this.providerOrderId,
    required this.from,
    required this.to,
    required this.fee,
    required this.merchantFee,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory BuyHistoryResponseItem.fromJson(Map<String, dynamic> json) =>
      _$BuyHistoryResponseItemFromJson(json);

  Map<String, dynamic> toJson() => _$BuyHistoryResponseItemToJson(this);
}

@JsonSerializable()
class PairFiatAsset {
  final String assetId;
  final int decimalPlaces;
  final double minimum;
  final double maximum;

  PairFiatAsset({
    required this.assetId,
    required this.decimalPlaces,
    required this.minimum,
    required this.maximum,
  });

  factory PairFiatAsset.fromJson(json) => _$PairFiatAssetFromJson(json);

  Map<String, dynamic> toJson() => _$PairFiatAssetToJson(this);
}

@JsonSerializable()
class PairCryptoAsset {
  final int assetId;
  final int networkId;

  PairCryptoAsset({
    required this.assetId,
    required this.networkId,
  });

  factory PairCryptoAsset.fromJson(Map<String, dynamic> json) =>
      _$PairCryptoAssetFromJson(json);

  Map<String, dynamic> toJson() => _$PairCryptoAssetToJson(this);
}

@JsonSerializable()
class BuyConvertResponse {
  final FiatAsset fiatAsset;
  final CryptoAsset cryptoAsset;
  final FeeAsset fee;

  BuyConvertResponse({
    required this.fiatAsset,
    required this.cryptoAsset,
    required this.fee,
  });

  factory BuyConvertResponse.fromJson(Map<String, dynamic> json) =>
      _$BuyConvertResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BuyConvertResponseToJson(this);
}

@JsonSerializable()
class FiatAsset {
  final String assetId;
  final double amount;

  FiatAsset({
    required this.assetId,
    required this.amount,
  });

  factory FiatAsset.fromJson(Map<String, dynamic> json) =>
      _$FiatAssetFromJson(json);

  Map<String, dynamic> toJson() => _$FiatAssetToJson(this);
}

@JsonSerializable()
class CryptoAsset {
  final int assetId;
  final double amount;

  CryptoAsset({
    required this.assetId,
    required this.amount,
  });

  factory CryptoAsset.fromJson(Map<String, dynamic> json) =>
      _$CryptoAssetFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoAssetToJson(this);
}

@JsonSerializable()
class FeeAsset {
  final String assetId;
  final String amount;

  FeeAsset({
    required this.assetId,
    required this.amount,
  });

  factory FeeAsset.fromJson(Map<String, dynamic> json) =>
      _$FeeAssetFromJson(json);

  Map<String, dynamic> toJson() => _$FeeAssetToJson(this);
}

@JsonSerializable()
class BuyOrderBody {
  final ConvertFiatAsset fiatAsset;
  final ConvertCryptoAssetWithoutAmount cryptoAsset;
  final ConvertTargetAmount targetAmount;
  final String walletAddress;
  final String applicantId;

  BuyOrderBody({
    required this.fiatAsset,
    required this.cryptoAsset,
    required this.targetAmount,
    required this.walletAddress,
    required this.applicantId,
  });

  factory BuyOrderBody.fromJson(Map<String, dynamic> json) =>
      _$BuyOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BuyOrderBodyToJson(this);
}

@JsonSerializable()
class BuyConvertBodyForFiat {
  final ConvertFiatAsset fiatAsset;
  final ConvertCryptoAssetWithoutAmount cryptoAsset;

  const BuyConvertBodyForFiat({
    required this.fiatAsset,
    required this.cryptoAsset,
  });

  factory BuyConvertBodyForFiat.fromJson(Map<String, dynamic> json) =>
      _$BuyConvertBodyForFiatFromJson(json);

  Map<String, dynamic> toJson() => _$BuyConvertBodyForFiatToJson(this);
}

@JsonSerializable()
class BuyConvertBodyForCrypto {
  final ConvertFiatAssetWithoutAmount fiatAsset;
  final ConvertCryptoAsset cryptoAsset;

  const BuyConvertBodyForCrypto({
    required this.fiatAsset,
    required this.cryptoAsset,
  });

  factory BuyConvertBodyForCrypto.fromJson(Map<String, dynamic> json) =>
      _$BuyConvertBodyForCryptoFromJson(json);

  Map<String, dynamic> toJson() => _$BuyConvertBodyForCryptoToJson(this);
}

@JsonSerializable()
class ConvertFiatAsset {
  final String assetId;
  final double? amount;

  ConvertFiatAsset({
    required this.assetId,
    this.amount,
  });

  factory ConvertFiatAsset.fromJson(Map<String, dynamic> json) =>
      _$ConvertFiatAssetFromJson(json);

  Map<String, dynamic> toJson() => _$ConvertFiatAssetToJson(this);
}

@JsonSerializable()
class ConvertFiatAssetWithoutAmount {
  final String assetId;

  ConvertFiatAssetWithoutAmount({required this.assetId});

  factory ConvertFiatAssetWithoutAmount.fromJson(Map<String, dynamic> json) =>
      _$ConvertFiatAssetWithoutAmountFromJson(json);

  Map<String, dynamic> toJson() => _$ConvertFiatAssetWithoutAmountToJson(this);
}

@JsonSerializable()
class ConvertCryptoAsset {
  final int assetId;
  final double? amount;

  ConvertCryptoAsset({
    required this.assetId,
    this.amount,
  });

  factory ConvertCryptoAsset.fromJson(Map<String, dynamic> json) =>
      _$ConvertCryptoAssetFromJson(json);

  Map<String, dynamic> toJson() => _$ConvertCryptoAssetToJson(this);
}

@JsonSerializable()
class ConvertCryptoAssetWithoutAmount {
  final int assetId;

  ConvertCryptoAssetWithoutAmount({required this.assetId});

  factory ConvertCryptoAssetWithoutAmount.fromJson(Map<String, dynamic> json) =>
      _$ConvertCryptoAssetWithoutAmountFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConvertCryptoAssetWithoutAmountToJson(this);
}

@JsonSerializable()
class ConvertTargetAmount {
  final String assetId;
  final double? amount;

  ConvertTargetAmount({
    required this.assetId,
    this.amount,
  });

  factory ConvertTargetAmount.fromJson(Map<String, dynamic> json) =>
      _$ConvertTargetAmountFromJson(json);

  Map<String, dynamic> toJson() => _$ConvertTargetAmountToJson(this);
}
