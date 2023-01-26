import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/account_service.dart';

class AccountApi extends HttpApi<AccountService> {
  Future<AccountProfileResponse> getAccountProfile() async {
    final res = await service.profile();

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception("Could not fetch account profile: ${res.error.toString()}");
  }

  Future<AccountProfileResponse> updateUserProfile(
    AccountProfileResponse userProfile,
  ) async {
    final res = await service.updateProfile(userProfile);

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception("Could not fetch account profile: ${res.error.toString()}");
  }
}
