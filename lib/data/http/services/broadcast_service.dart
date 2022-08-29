import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'broadcast_service.chopper.dart';
part 'broadcast_service.g.dart';

@ChopperApi(baseUrl: '/blockchain')
abstract class BroadcastService extends ChopperService {
  static BroadcastService create() => _$BroadcastService();
  static FactoryConvertMap converter() => {
        BroadcastResponse: BroadcastResponse.fromJson,
      };

  @Get(path: '/broadcast')
  Future<Response<BroadcastResponse>> transaction(
    @Query('network') String networkId,
    @Query() String transaction,
  );
}

@JsonSerializable()
class BroadcastResponse {
  final bool success;
  final String? errorMessage;
  final String? result;

  const BroadcastResponse({
    required this.success,
    required this.errorMessage,
    required this.result,
  });

  factory BroadcastResponse.fromJson(Map<String, dynamic> json) =>
      _$BroadcastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BroadcastResponseToJson(this);
}
