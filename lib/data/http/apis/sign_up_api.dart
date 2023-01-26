import 'dart:io';

import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/sign_up_service.dart';
import 'package:simplio_app/data/models/account.dart';

typedef AfterSignUpCallback = Future<Account> Function(
  String email,
  String password,
);

class SignUpApi extends HttpApi<SignUpService> {
  Future<Account> signUp(
    String email,
    String password, {
    required AfterSignUpCallback afterSignUp,
  }) async {
    final response = await service.signUp(SignUpBody(
      email: email,
      password: password,
    ));

    if (response.isSuccessful) {
      return afterSignUp(email, password);
    }

    //TODO: Handle the error in the future with HttpErrorCodes and codes that
    // come from backend. In this case the response comming from backend is:
    // { "ErrorCode":"AUTH_USER_REGISTRATION_FAILED",
    // "ErrorMessage":"{ code = DUPLICATE }", "StatusCode":409 }
    // but we do not take it into consideration
    if (response.statusCode == HttpStatus.conflict) {
      throw Exception('Account already exists');
    }

    throw Exception("Sign up has failed");
  }
}
