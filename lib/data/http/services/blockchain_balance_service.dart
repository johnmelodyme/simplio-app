import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'blockchain_balance_service.chopper.dart';
part 'blockchain_balance_service.g.dart';

@ChopperApi(baseUrl: '/blockchain')
abstract class BlockchainBalanceService extends ChopperService {
  static BlockchainBalanceService create() => _$BlockchainBalanceService();
  static FactoryConvertMap converter() => {
        BalanceResponse: BalanceResponse.fromJson,
      };

  @Get(path: '/balance')
  Future<Response<BalanceResponse>> balance({
    @Query('network') required String networkId,
    @Query('wallet') required String walletAddress,
  });
}

@JsonSerializable()
class BalanceResponse {
  final String address;
  final BigInt balance;
  final BigInt totalReceived;
  final BigInt totalSent;
  final bool success;
  final String? errorMessage;

  const BalanceResponse({
    required this.address,
    required this.balance,
    required this.totalReceived,
    required this.totalSent,
    required this.success,
    this.errorMessage,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);
}
