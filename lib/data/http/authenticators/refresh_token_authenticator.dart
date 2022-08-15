import 'dart:async';
import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/model/auth_token.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/providers/storage_provider.dart';

class RefreshTokenAuthenticator extends Authenticator {
  final StorageProvider<AuthToken> authTokenStorage;
  final RefreshTokenService refreshTokenService;

  RefreshTokenAuthenticator({
    required this.authTokenStorage,
    required this.refreshTokenService,
  });

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode == HttpStatus.unauthorized) {
      final refreshToken = _loadRefreshToken();
      final authToken = await _refreshToken(refreshToken);

      return request.copyWith(headers: {
        ...request.headers,
        "Authorization": "${authToken.tokenType} ${authToken.accessToken}",
      });
    }

    return null;
  }

  Future<AuthToken> _refreshToken(String refreshToken) async {
    final response = await refreshTokenService.refreshToken(
      RefreshTokenBody(refreshToken: refreshToken),
    );

    final body = response.body;

    if (response.isSuccessful && body != null) {
      final authToken = AuthToken(
        refreshToken: body.refreshToken,
        accessToken: body.accessToken,
        tokenType: body.tokenType,
      );

      await authTokenStorage.write(authToken);

      return authToken;
    }

    throw Exception("Refreshing token has failed");
  }

  String _loadRefreshToken() {
    final token = authTokenStorage.read();
    return token.refreshToken;
  }
}
