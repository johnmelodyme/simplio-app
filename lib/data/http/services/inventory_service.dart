import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'inventory_service.chopper.dart';
part 'inventory_service.g.dart';

@ChopperApi(baseUrl: '/inventory')
abstract class InventoryService extends ChopperService {
  static InventoryService create() => _$InventoryService();
  static FactoryConvertMap converter() => {
        UserWallet: UserWallet.fromJson,
        BalanceBody: BalanceBody.fromJson,
        DetailBody: DetailBody.fromJson,
        TransactionsBody: TransactionsBody.fromJson,
        Asset: Asset.fromJson,
        Wallet: Wallet.fromJson,
        BalanceResponse: BalanceResponse.fromJson,
        Transaction: Transaction.fromJson,
        DetailResponse: DetailResponse.fromJson,
        TransactionsResponse: TransactionsResponse.fromJson,
      };

  @Post(path: '/balance')
  Future<Response<BalanceResponse>> balance(
    @Body() BalanceBody body,
  );

  @Post(path: '/detail')
  Future<Response<DetailResponse>> detail(
    @Body() DetailBody body,
  );

  @Post(path: '/transactions')
  Future<Response<TransactionsResponse>> transactions(
    @Body() TransactionsBody body,
  );
}

@JsonSerializable()
class UserWallet {
  final String address;
  final List<int> assetsIds;
  final int networkId;

  const UserWallet({
    required this.address,
    required this.assetsIds,
    required this.networkId,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) =>
      _$UserWalletFromJson(json);

  Map<String, dynamic> toJson() => _$UserWalletToJson(this);
}

@JsonSerializable()
class BalanceBody {
  final List<UserWallet> userWallets;
  final String fiatAssetId;

  const BalanceBody({
    required this.userWallets,
    required this.fiatAssetId,
  });

  factory BalanceBody.fromJson(Map<String, dynamic> json) =>
      _$BalanceBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceBodyToJson(this);
}

@JsonSerializable()
class DetailBody {
  final UserWallet wallet;
  final String fiatAssetId;

  const DetailBody({
    required this.wallet,
    required this.fiatAssetId,
  });

  factory DetailBody.fromJson(Map<String, dynamic> json) =>
      _$DetailBodyFromJson(json);

  Map<String, dynamic> toJson() => _$DetailBodyToJson(this);
}

@JsonSerializable()
class TransactionsBody {
  final List<Wallet> wallets;
  final String fiatAssetId;
  final DateTime fromDate;
  final DateTime toDate;
  final int page;
  final int pageSize;

  const TransactionsBody({
    required this.wallets,
    required this.fiatAssetId,
    required this.fromDate,
    required this.toDate,
    required this.page,
    required this.pageSize,
  });

  factory TransactionsBody.fromJson(Map<String, dynamic> json) =>
      _$TransactionsBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsBodyToJson(this);
}

@JsonSerializable()
class Asset {
  final int assetId;
  final String balance;
  final double fiatValue;
  final bool success;
  final String? errorMessage;

  const Asset({
    required this.assetId,
    required this.balance,
    required this.fiatValue,
    required this.success,
    required this.errorMessage,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);
}

@JsonSerializable()
class Wallet {
  final String walletAddress;
  final int networkId;
  final double totalBalance;
  final List<Asset> assets;

  const Wallet({
    required this.walletAddress,
    required this.networkId,
    required this.totalBalance,
    required this.assets,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);
}

@JsonSerializable()
class BalanceResponse {
  final double totalBalance;
  final String fiatAssetId;
  final List<Wallet> wallets;

  const BalanceResponse({
    required this.totalBalance,
    required this.fiatAssetId,
    required this.wallets,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);
}

@JsonSerializable()
class Transaction {
  final int assetId;
  final int networkId;
  final String assetName;
  final String txType;
  final DateTime dateTime;
  final double tokenAmount;
  final double fiatAmount;

  const Transaction({
    required this.assetId,
    required this.networkId,
    required this.assetName,
    required this.txType,
    required this.dateTime,
    required this.tokenAmount,
    required this.fiatAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class DetailResponse {
  final Asset asset;
  final List<Transaction> transactions;

  const DetailResponse({
    required this.asset,
    required this.transactions,
  });

  factory DetailResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailResponseToJson(this);
}

@JsonSerializable()
class TransactionsResponse {
  final double totalBalance;
  final List<Transaction> transactions;
  final int totalTransactions;

  const TransactionsResponse({
    required this.totalBalance,
    required this.transactions,
    required this.totalTransactions,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsResponseToJson(this);
}
