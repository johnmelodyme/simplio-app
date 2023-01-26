import 'dart:async';
import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/http/apis/refresh_token_api.dart';
import 'package:simplio_app/data/providers/entities/auth_token_entity.dart';
import 'package:simplio_app/data/providers/helpers/storage_provider.dart';

class RefreshTokenAuthenticator extends Authenticator {
  final StorageProvider<AuthTokenEntity> authTokenStorage;
  final RefreshTokenApi refreshTokenApi;

  RefreshTokenAuthenticator({
    required this.authTokenStorage,
    required this.refreshTokenApi,
  });

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode == HttpStatus.unauthorized) {
      final refreshToken = _loadRefreshToken();
      final authToken = await refreshTokenApi.refreshToken(refreshToken);

      await authTokenStorage.write(authToken);

      return request.copyWith(headers: {
        ...request.headers,
        "Authorization": "${authToken.tokenType} ${authToken.accessToken}",
      });
    }

    return null;
  }

  String _loadRefreshToken() {
    final token = authTokenStorage.read();
    return token.refreshToken;
  }
}
