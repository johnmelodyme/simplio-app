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
  final String? locales;

  final List<int>? assets;
  final List<int>? gameFavorite;
  late List<int>? gameLibrary;

  final bool isMarketingApproved;
  final DateTime? marketingApprovedAt;
  final bool isTermsAndConditionApproved;
  final DateTime? termsAndConditionApprovedAt;
  final bool isDarkModeActivated;
  final String? lastLoggedDeviceId;
  final bool isSumSubReviewed;
  @JsonKey(name: 'isSumSubApproved')
  final bool isVerified;

  @JsonKey(name: 'sumSubApplicationUserId')
  final String? applicantId;

  final String email;
  final String? phone;
  final List<AccountWalletResponse>? wallets;

  AccountProfileResponse(
      {required this.accountId,
      required this.locales,
      required this.assets,
      required this.gameFavorite,
      required this.gameLibrary,
      required this.isMarketingApproved,
      required this.marketingApprovedAt,
      required this.isTermsAndConditionApproved,
      required this.termsAndConditionApprovedAt,
      required this.isDarkModeActivated,
      required this.lastLoggedDeviceId,
      required this.isSumSubReviewed,
      required this.isVerified,
      required this.applicantId,
      required this.email,
      required this.phone,
      required this.wallets});

  factory AccountProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountProfileResponseToJson(this);
}

// TODO - do not name object as domains models!
@JsonSerializable()
class AccountWalletResponse {
  final String walletAddress;
  final int networkId;
  final List<int> assets;

  AccountWalletResponse({
    required this.walletAddress,
    required this.networkId,
    required this.assets,
  });

  factory AccountWalletResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountWalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountWalletResponseToJson(this);
}
