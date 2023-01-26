import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/password_change_service.dart';

class PasswordChangeApi extends HttpApi<PasswordChangeService> {
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final response = await service.changePassword(PasswordChangeBody(
      oldPassword: oldPassword,
      newPassword: newPassword,
    ));

    if (response.isSuccessful) return;

    throw Exception("Changing a password has failed");
  }
}
