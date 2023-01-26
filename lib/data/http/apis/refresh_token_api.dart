import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/providers/entities/auth_token_entity.dart';

class RefreshTokenApi extends HttpApi<RefreshTokenService> {
  Future<AuthTokenEntity> refreshToken(String refreshToken) async {
    final response = await service.refreshToken(
      RefreshTokenBody(refreshToken: refreshToken),
    );

    final body = response.body;

    if (response.isSuccessful && body != null) {
      final authToken = AuthTokenEntity(
        refreshToken: body.refreshToken,
        accessToken: body.accessToken,
        tokenType: body.tokenType,
      );

      return authToken;
    }

    throw Exception("Refreshing token has failed");
  }
}
