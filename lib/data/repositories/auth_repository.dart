import 'dart:io';

import 'package:simplio_app/data/http/services/password_change_service.dart';
import 'package:simplio_app/data/http/services/password_reset_service.dart';
import 'package:simplio_app/data/http/services/sign_in_service.dart';
import 'package:simplio_app/data/http/services/sign_up_service.dart';
import 'package:simplio_app/data/mixins/jwt_mixin.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/auth_token.dart';
import 'package:simplio_app/data/providers/storage_provider.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';

class AuthRepository with JwtMixin {
  final AccountDb _accountDb;
  final StorageProvider<AuthToken> _authTokenStorage;
  final SignInService _signInService;
  final SignUpService _signUpService;
  final PasswordChangeService _passwordChangeService;
  final PasswordResetService _passwordResetService;

  const AuthRepository._(
    this._accountDb,
    this._authTokenStorage,
    this._signInService,
    this._signUpService,
    this._passwordChangeService,
    this._passwordResetService,
  );

  const AuthRepository.builder({
    required AccountDb accountDb,
    required StorageProvider<AuthToken> authTokenStorage,
    required SignInService signInService,
    required SignUpService signUpService,
    required PasswordChangeService passwordChangeService,
    required PasswordResetService passwordResetService,
  }) : this._(
          accountDb,
          authTokenStorage,
          signInService,
          signUpService,
          passwordChangeService,
          passwordResetService,
        );

  Account? getLastSignedIn() {
    return _accountDb.getLast();
  }

  Future<Account> signUp(String email, String password) async {
    final response = await _signUpService.signUp(SignUpBody(
      email: email,
      password: password,
    ));

    if (response.isSuccessful) {
      return await signIn(email, password);
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

  Future<Account> _registerSignIn(String accountId) async {
    final acc = _accountDb.get(accountId);

    if (acc != null) {
      return _accountDb.save(acc.copyWith(
        signedIn: DateTime.now(),
        securityAttempts: securityAttemptsLimit,
      ));
    }

    return _accountDb.save(Account.registered(
      id: accountId,
      signedIn: DateTime.now(),
    ));
  }

  Future<Account> signIn(String login, String password) async {
    try {
      final response = await _signInService.signIn(SignInBody(
        email: login,
        password: password,
      ));

      final body = response.body;

      if (response.isSuccessful && body != null) {
        const accountIdKey = 'sub';
        final decodedIdToken = parseJwt(body.idToken);

        if (!decodedIdToken.containsKey(accountIdKey)) {
          throw Exception("Provided IdToken has missing 'name' field.");
        }

        await _authTokenStorage.write(AuthToken(
          refreshToken: body.refreshToken,
          tokenType: body.tokenType,
          accessToken: body.accessToken,
        ));

        return await _registerSignIn(decodedIdToken[accountIdKey]);
      }

      throw Exception(response.error);
    } catch (e) {
      throw Exception("Sign in has failed");
    }
  }

  Future<void> signOut({required String accountId}) async {
    final Account? account = _accountDb.get(accountId);

    if (account != null) {
      await _accountDb.save(account.copyWith(
        signedIn: DateTime.fromMillisecondsSinceEpoch(0),
      ));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final response =
        await _passwordChangeService.changePassword(PasswordChangeBody(
      oldPassword: oldPassword,
      newPassword: newPassword,
    ));

    if (response.isSuccessful) return;

    throw Exception("Changing a password has failed");
  }

  Future<void> resetPassword(String email) async {
    final response = await _passwordResetService.resetPassword(
      PasswordResetBody(email: email),
    );

    if (response.isSuccessful) return;

    throw Exception("Resetting a password has failed");
  }
}
