import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'transaction_history_service.chopper.dart';
part 'transaction_history_service.g.dart';

@ChopperApi(baseUrl: '/blockchain')
abstract class TransactionHistoryService extends ChopperService {
  static TransactionHistoryService create() => _$TransactionHistoryService();
  static FactoryConvertMap converter() => {
        TransactionHistoryResponse: TransactionHistoryResponse.fromJson,
      };

  @Get(path: '/history')
  Future<Response<TransactionHistoryResponse>> coin(
    @Query('network') String networkId,
    @Query('wallet') String walletAddress,
    @Query() String? page,
    @Query('pageSize') String? transactionsPerPage,
  );

  @Get(path: '/history-for-token')
  Future<Response<TransactionHistoryResponse>> token(
    @Query('network') String networkId,

    /// Empty in case of Solana network.
    @Query('wallet') String? walletAddress,

    /// ContractAddress for Ethereum alike networks.
    /// TokenAccount for Solana network.
    @Query() String contractAddress,

    /// The page number in case of too many transactions.
    /// Empty for Solana network.
    @Query() String? page,

    /// The number of transaction on each page.
    /// For Solana network is the transaction limit of the call.
    @Query('pageSize') String? transactionsPerPage,
  );
}

@JsonSerializable()
class Transaction {
  final String? txType;
  final String? address;
  final String? amount;
  final String? txId;
  final String? networkFee;
  final int? unixTime;
  final bool confirmed;

  const Transaction({
    required this.txType,
    required this.address,
    required this.amount,
    required this.txId,
    required this.networkFee,
    required this.unixTime,
    required this.confirmed,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class TransactionHistoryResponse {
  final String? walletAddress;
  final String? contractAddress;
  final List<Transaction> transactions;
  final bool success;
  final String? errorMessage;

  const TransactionHistoryResponse({
    required this.walletAddress,
    required this.contractAddress,
    required this.transactions,
    required this.success,
    required this.errorMessage,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionHistoryResponseToJson(this);
}
