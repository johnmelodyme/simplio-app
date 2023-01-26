import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/sign_in_service.dart';

class SignInApi extends HttpApi<SignInService> {
  Future<SignInResponse> signIn(String login, String password) async {
    final response = await service.signIn(SignInBody(
      email: login,
      password: password,
    ));

    final body = response.body;

    if (response.isSuccessful && body != null) {
      return body;
    }

    throw Exception(response.error);
  }
}
