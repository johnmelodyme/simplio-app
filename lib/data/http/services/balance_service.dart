import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'balance_service.chopper.dart';
part 'balance_service.g.dart';

@ChopperApi(baseUrl: '/blockchain')
abstract class BalanceService extends ChopperService {
  static BalanceService create() => _$BalanceService();
  static FactoryConvertMap converter() => {
        BalanceResponse: BalanceResponse.fromJson,
      };

  @Get(path: '/balance')
  Future<Response<BalanceResponse>> coin(
    @Query('network') String networkId,
    @Query('wallet') String walletAddress,
  );

  @Get(path: '/balance-for-token')
  Future<Response<BalanceResponse>> token(
    @Query('network') String networkId,
    @Query('wallet') String walletAddress,
    @Query() String contractAddress,
  );
}

@JsonSerializable()
class BalanceResponse {
  final String walletAddress;
  final String? contractAddress;
  final int balance;
  final bool success;
  final String? errorMessage;

  const BalanceResponse({
    required this.walletAddress,
    required this.contractAddress,
    required this.balance,
    required this.success,
    required this.errorMessage,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);
}
