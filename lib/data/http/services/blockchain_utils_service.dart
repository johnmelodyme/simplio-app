import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'blockchain_utils_service.chopper.dart';
part 'blockchain_utils_service.g.dart';

@ChopperApi(baseUrl: '/blockchain')
abstract class BlockchainUtilsService extends ChopperService {
  static BlockchainUtilsService create() => _$BlockchainUtilsService();
  static FactoryConvertMap converter() => {
        EthereumUtilsResponse: EthereumUtilsResponse.fromJson,
        SolanaUtilsResponse: SolanaUtilsResponse.fromJson,
      };

  @Get(path: '/utils')
  Future<Response<EthereumUtilsResponse>> ethereum({
    @Query('network') required String networkId,
    @Query('wallet') required String walletAddress,
  });

  @Get(path: '/utils')
  Future<Response<SolanaUtilsResponse>> solana({
    @Query('network') String networkId = "501",
    @Query('wallet') required String walletAddress,
  });

  @Get(path: '/utils')
  Future<Response<UtxoUtilsResponse>> utxo({
    @Query('network') required String networkId,
    @Query('wallet') required String walletAddress,
  });
}

@JsonSerializable()
class Utxo {
  final String? txid;
  final int? vout;
  final String? value;
  final int? height;
  final int? confirmations;
  final String? scriptPubKey;

  const Utxo({
    required this.txid,
    required this.vout,
    required this.value,
    required this.height,
    required this.confirmations,
    required this.scriptPubKey,
  });

  factory Utxo.fromJson(Map<String, dynamic> json) => _$UtxoFromJson(json);

  Map<String, dynamic> toJson() => _$UtxoToJson(this);
}

@JsonSerializable()
class UtxoUtilsResponse {
  final List<Utxo> items;
  final bool success;
  final String? errorMessage;

  const UtxoUtilsResponse({
    required this.items,
    required this.success,
    required this.errorMessage,
  });

  factory UtxoUtilsResponse.fromJson(Map<String, dynamic> json) =>
      _$UtxoUtilsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UtxoUtilsResponseToJson(this);
}

@JsonSerializable()
class SolanaUtilsResponse {
  final String? lastBlockHash;
  final bool success;
  final String? errorMessage;

  const SolanaUtilsResponse({
    required this.lastBlockHash,
    required this.success,
    required this.errorMessage,
  });

  factory SolanaUtilsResponse.fromJson(Map<String, dynamic> json) =>
      _$SolanaUtilsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SolanaUtilsResponseToJson(this);
}

@JsonSerializable()
class EthereumUtilsResponse {
  final String address;
  final String? transactionCount;
  final bool success;
  final String? errorMessage;

  const EthereumUtilsResponse({
    required this.address,
    required this.transactionCount,
    required this.success,
    required this.errorMessage,
  });

  factory EthereumUtilsResponse.fromJson(Map<String, dynamic> json) =>
      _$EthereumUtilsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EthereumUtilsResponseToJson(this);
}
