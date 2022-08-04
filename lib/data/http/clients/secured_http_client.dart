import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/http/authenticators/refresh_token_authenticator.dart';
import 'package:simplio_app/data/http/clients/http_client.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';
import 'package:simplio_app/data/http/interceptors/api_key_interceptor.dart';
import 'package:simplio_app/data/http/interceptors/authorize_interceptor.dart';
import 'package:simplio_app/data/http/services/password_change_service.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/model/auth_token.dart';
import 'package:simplio_app/data/providers/storage_provider.dart';

class SecuredHttpClient extends HttpClient {
  @override
  final ChopperClient client;

  SecuredHttpClient._(this.client);

  SecuredHttpClient.builder(
    String url, {
    required StorageProvider<AuthToken> authTokenStorage,
    required RefreshTokenService refreshTokenService,
  }) : this._(
          ChopperClient(
            baseUrl: url,
            converter: JsonSerializableConverter({
              ...PasswordChangeService.converter(),
            }),
            authenticator: RefreshTokenAuthenticator(
              authTokenStorage: authTokenStorage,
              refreshTokenService: refreshTokenService,
            ),
            interceptors: [
              ApiKeyInterceptor(),
              AuthorizeInterceptor(authTokenStorage: authTokenStorage),
            ],
            services: [
              PasswordChangeService.create(),
            ],
          ),
        );
}
