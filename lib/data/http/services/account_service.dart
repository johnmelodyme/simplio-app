import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';

part 'account_service.chopper.dart';
part 'account_service.g.dart';

@ChopperApi(baseUrl: '/users')
abstract class AccountService extends ChopperService {
  static AccountService create() => _$AccountService();
  static FactoryConvertMap converter() => {
        AccountProfileResponse: AccountProfileResponse.fromJson,
      };

  @Get(path: '/settings')
  Future<Response<AccountProfileResponse>> profile();

  @Post(path: '/settings')
  Future<Response<AccountProfileResponse>> updateProfile(
    @Body() AccountProfileResponse body,
  );
}

@JsonSerializable()
class AccountProfileResponse {
  @JsonKey(name: 'userId')
  final String accountId;
  final String locales;

  @JsonKey(name: 'isSumSubApproved')
  final bool isVerified;

  @JsonKey(name: 'sumSubApplicationUserId')
  final String? applicantId;

  const AccountProfileResponse({
    required this.accountId,
    required this.locales,
    required this.isVerified,
    this.applicantId,
  });

  factory AccountProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountProfileResponseToJson(this);
}
