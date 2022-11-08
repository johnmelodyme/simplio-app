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

  final List<int>? assets;
  List<int>? gameFavorite;
  List<int>? gameLibrary;

  final bool isMarketingApproved;
  final String? marketingApprovedAt;
  final bool isTermsAndConditionApproved;
  final String? termsAndConditionApprovedAt;
  final bool isDarkModeActivated;
  final String? lastLoggedDeviceId;
  final bool isSumSubReviewed;
  @JsonKey(name: 'isSumSubApproved')
  final bool isVerified;

  @JsonKey(name: 'sumSubApplicationUserId')
  final String? applicantId;

  final String email;
  final String phone;

  AccountProfileResponse({
    required this.accountId,
    required this.locales,
    this.assets,
    this.gameFavorite,
    this.gameLibrary,
    required this.isMarketingApproved,
    this.marketingApprovedAt,
    required this.isTermsAndConditionApproved,
    this.termsAndConditionApprovedAt,
    required this.isDarkModeActivated,
    this.lastLoggedDeviceId,
    required this.isSumSubReviewed,
    required this.isVerified,
    this.applicantId,
    required this.email,
    required this.phone,
  });

  factory AccountProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountProfileResponseToJson(this);
}
