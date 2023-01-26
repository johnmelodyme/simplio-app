import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/password_reset_service.dart';

class PasswordResetApi extends HttpApi<PasswordResetService> {
  Future<void> resetPassword(String email) async {
    final response = await service.resetPassword(
      PasswordResetBody(email: email),
    );

    if (response.isSuccessful) return;

    throw Exception("Resetting a password has failed");
  }
}
