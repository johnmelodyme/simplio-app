import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';
import 'package:simplio_app/data/models/wallet.dart';

part 'wallet_inventory_service.chopper.dart';
part 'wallet_inventory_service.g.dart';

@ChopperApi(baseUrl: '/inventory')
abstract class WalletInventoryService extends ChopperService {
  static WalletInventoryService create() => _$WalletInventoryService();
  static FactoryConvertMap converter() => {
        AccountWalletBalanceResponse: AccountWalletBalanceResponse.fromJson,
        AccountWalletTransactionsResponse:
            AccountWalletTransactionsResponse.fromJson,
        NetworkWalletInventoryResponse: NetworkWalletInventoryResponse.fromJson,
      };

  @Post(path: '/balance')
  Future<Response<AccountWalletBalanceResponse>> accountWalletBalance(
    @Body() AccountWalletBalanceRequest request,
  );

  @Post(path: '/transactions')
  Future<Response<AccountWalletTransactionsResponse>> accountWalletTransactions(
    @Body() AccountWalletTransactionsRequest request,
  );

  @Post(path: '/detail')
  Future<Response<NetworkWalletInventoryResponse>> networkWalletInventory(
    @Body() NetworkWalletInventoryRequest request,
  );
}

@JsonSerializable()
class AccountWalletBalanceRequest {
  @JsonKey(name: 'fiatAssetId')
  final String currency;
  @JsonKey(name: 'cryptoAssets')
  final List<AccountWalletAssetItemRequest> assets;

  const AccountWalletBalanceRequest({
    required this.currency,
    required this.assets,
  });

  factory AccountWalletBalanceRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountWalletBalanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AccountWalletBalanceRequestToJson(this);
}

@JsonSerializable()
class AccountWalletAssetItemRequest {
  @JsonKey(name: 'cryptoAssetId')
  final AssetId assetId;
  final List<AccountWalletNetworkItemRequest> networks;

  const AccountWalletAssetItemRequest({
    required this.assetId,
    required this.networks,
  });

  factory AccountWalletAssetItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountWalletAssetItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AccountWalletAssetItemRequestToJson(this);
}

@JsonSerializable()
class AccountWalletNetworkItemRequest {
  final NetworkId networkId;
  final String walletAddress;
  @JsonKey(name: 'originalCryptoBalance')
  final String cryptoBalance;

  const AccountWalletNetworkItemRequest({
    required this.networkId,
    required this.walletAddress,
    required this.cryptoBalance,
  });

  factory AccountWalletNetworkItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AccountWalletNetworkItemRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletNetworkItemRequestToJson(this);
}

@JsonSerializable()
class NetworkWalletInventoryTransactionItemResponse {
  @JsonKey(name: 'cryptoAssetId')
  final int assetId;
  final int networkId;
  final String status;
  final String assetName;
  final String txType;
  final DateTime createdAt;
  final String cryptoAmount;
  final double fiatAmount;

  const NetworkWalletInventoryTransactionItemResponse({
    required this.assetId,
    required this.networkId,
    required this.status,
    required this.assetName,
    required this.txType,
    required this.createdAt,
    required this.cryptoAmount,
    required this.fiatAmount,
  });

  factory NetworkWalletInventoryTransactionItemResponse.fromJson(
          Map<String, dynamic> json) =>
      _$NetworkWalletInventoryTransactionItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NetworkWalletInventoryTransactionItemResponseToJson(this);
}

@JsonSerializable()
class AccountWalletTransactionsRequest {
  @JsonKey(name: 'fiatAssetId')
  final String currency;
  final DateTime fromDate;
  final DateTime toDate;
  final int page;
  final int pageSize;
  @JsonKey(name: 'cryptoAssets')
  final List<AccountWalletTransactionsAssetItemRequest> assets;

  const AccountWalletTransactionsRequest({
    required this.currency,
    required this.fromDate,
    required this.toDate,
    required this.page,
    required this.pageSize,
    required this.assets,
  });

  factory AccountWalletTransactionsRequest.fromJson(
          Map<String, dynamic> json) =>
      _$AccountWalletTransactionsRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletTransactionsRequestToJson(this);
}

@JsonSerializable()
class AccountWalletTransactionsResponse {
  final double totalFiatBalance;
  final List<NetworkWalletInventoryTransactionItemResponse> transactions;

  const AccountWalletTransactionsResponse({
    required this.totalFiatBalance,
    required this.transactions,
  });

  factory AccountWalletTransactionsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AccountWalletTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletTransactionsResponseToJson(this);
}

@JsonSerializable()
class AccountWalletTransactionsAssetItemRequest {
  @JsonKey(name: 'cryptoAssetId')
  final int assetId;
  final List<AccountWalletTransactionsNetworkItemRequest> networks;

  const AccountWalletTransactionsAssetItemRequest({
    required this.assetId,
    required this.networks,
  });

  factory AccountWalletTransactionsAssetItemRequest.fromJson(
          Map<String, dynamic> json) =>
      _$AccountWalletTransactionsAssetItemRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletTransactionsAssetItemRequestToJson(this);
}

@JsonSerializable()
class AccountWalletTransactionsNetworkItemRequest {
  final int networkId;
  final String walletAddress;

  const AccountWalletTransactionsNetworkItemRequest({
    required this.networkId,
    required this.walletAddress,
  });

  factory AccountWalletTransactionsNetworkItemRequest.fromJson(
          Map<String, dynamic> json) =>
      _$AccountWalletTransactionsNetworkItemRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletTransactionsNetworkItemRequestToJson(this);
}

@JsonSerializable()
class AccountWalletBalanceResponse {
  final double fiatTotalBalance;
  @JsonKey(name: 'fiatAssetId')
  final String currency;
  @JsonKey(name: 'cryptoAssets')
  final List<AccountWalletBalanceAssetItemResponse> assets;

  const AccountWalletBalanceResponse({
    required this.fiatTotalBalance,
    required this.currency,
    required this.assets,
  });

  factory AccountWalletBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountWalletBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountWalletBalanceResponseToJson(this);
}

@JsonSerializable()
class AccountWalletBalanceAssetItemResponse {
  @JsonKey(name: 'cryptoAssetId')
  final int assetId;

  final String cryptoBalance;
  final double fiatBalance;
  final List<AccountWalletBalanceNetworkItemResponse> networks;

  const AccountWalletBalanceAssetItemResponse({
    required this.assetId,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.networks,
  });

  factory AccountWalletBalanceAssetItemResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AccountWalletBalanceAssetItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletBalanceAssetItemResponseToJson(this);
}

@JsonSerializable()
class AccountWalletBalanceNetworkItemResponse {
  final int networkId;
  final String walletAddress;
  final String cryptoBalance;
  final double fiatBalance;
  final bool success;
  final String? errorMessage;

  const AccountWalletBalanceNetworkItemResponse({
    required this.networkId,
    required this.walletAddress,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.success,
    this.errorMessage,
  });

  factory AccountWalletBalanceNetworkItemResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AccountWalletBalanceNetworkItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccountWalletBalanceNetworkItemResponseToJson(this);
}

@JsonSerializable()
class NetworkWalletInventoryRequest {
  @JsonKey(name: 'fiatAssetId')
  final String currency;
  @JsonKey(name: 'cryptoAsset')
  final NetworkWalletInventoryAssetItemRequest asset;

  const NetworkWalletInventoryRequest({
    required this.currency,
    required this.asset,
  });

  factory NetworkWalletInventoryRequest.fromJson(Map<String, dynamic> json) =>
      _$NetworkWalletInventoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkWalletInventoryRequestToJson(this);
}

@JsonSerializable()
class NetworkWalletInventoryAssetItemRequest {
  @JsonKey(name: 'cryptoAssetId')
  final int assetId;
  final int networkId;
  final String walletAddress;

  const NetworkWalletInventoryAssetItemRequest({
    required this.assetId,
    required this.networkId,
    required this.walletAddress,
  });

  factory NetworkWalletInventoryAssetItemRequest.fromJson(
          Map<String, dynamic> json) =>
      _$NetworkWalletInventoryAssetItemRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NetworkWalletInventoryAssetItemRequestToJson(this);
}

@JsonSerializable()
class NetworkWalletInventoryResponse {
  @JsonKey(name: 'cryptoAssetId')
  final int assetId;
  final String cryptoBalance;
  final double fiatBalance;
  final bool success;
  final String? errorMessage;
  final List<NetworkWalletInventoryTransactionItemResponse> transactions;

  const NetworkWalletInventoryResponse({
    required this.assetId,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.success,
    this.errorMessage,
    required this.transactions,
  });

  factory NetworkWalletInventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$NetworkWalletInventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkWalletInventoryResponseToJson(this);
}
