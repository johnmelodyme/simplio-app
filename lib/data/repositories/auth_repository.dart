import 'package:simplio_app/data/http/apis/password_change_api.dart';
import 'package:simplio_app/data/http/apis/password_reset_api.dart';
import 'package:simplio_app/data/http/apis/sign_in_api.dart';
import 'package:simplio_app/data/http/apis/sign_up_api.dart';
import 'package:simplio_app/data/mixins/jwt_mixin.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/providers/entities/auth_token_entity.dart';
import 'package:simplio_app/data/providers/helpers/storage_provider.dart';
import 'package:simplio_app/data/providers/interfaces/account_db.dart';

class AuthRepository with JwtMixin {
  final AccountDb _accountDb;
  final StorageProvider<AuthTokenEntity> _authTokenStorage;
  final SignInApi _signInApi;
  final SignUpApi _signUpApi;
  final PasswordChangeApi _passwordChangeApi;
  final PasswordResetApi _passwordResetApi;

  const AuthRepository._(
    this._accountDb,
    this._authTokenStorage,
    this._signInApi,
    this._signUpApi,
    this._passwordChangeApi,
    this._passwordResetApi,
  );

  const AuthRepository({
    required AccountDb accountDb,
    required StorageProvider<AuthTokenEntity> authTokenStorage,
    required SignInApi signInApi,
    required SignUpApi signUpApi,
    required PasswordChangeApi passwordChangeApi,
    required PasswordResetApi passwordResetApi,
  }) : this._(
          accountDb,
          authTokenStorage,
          signInApi,
          signUpApi,
          passwordChangeApi,
          passwordResetApi,
        );

  Future<Account?> getLastSignedIn() async {
    return _accountDb.getLast();
  }

  Future<Account> signUp(String email, String password) {
    return _signUpApi.signUp(
      email,
      password,
      afterSignUp: signIn,
    );
  }

  Future<Account> _registerSignIn(String accountId) async {
    final acc = await _accountDb.get(accountId);

    if (acc != null) {
      return await _accountDb.save(acc.copyWith(
        signedIn: DateTime.now(),
        securityAttempts: securityAttemptsLimit,
      ));
    }

    return _accountDb.save(Account.registered(
      id: accountId,
      signedIn: DateTime.now(),
    ));
  }

  Future<Account> signIn(
    String login,
    String password,
  ) async {
    try {
      final res = await _signInApi.signIn(login, password);

      const accountIdKey = 'sub';
      final decodedIdToken = parseJwt(res.idToken);

      await _authTokenStorage.write(AuthTokenEntity(
        refreshToken: res.refreshToken,
        tokenType: res.tokenType,
        accessToken: res.accessToken,
      ));

      return await _registerSignIn(decodedIdToken[accountIdKey]);
    } catch (e) {
      throw Exception("Sign in has failed");
    }
  }

  Future<void> signOut({required String accountId}) async {
    final Account? account = await _accountDb.get(accountId);

    if (account != null) {
      await _accountDb.save(account.copyWith(
        signedIn: DateTime.fromMillisecondsSinceEpoch(0),
      ));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) {
    return _passwordChangeApi.changePassword(oldPassword, newPassword);
  }

  Future<void> resetPassword(String email) {
    return _passwordResetApi.resetPassword(email);
  }
}
