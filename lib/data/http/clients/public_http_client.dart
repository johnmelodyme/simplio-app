import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/http/clients/http_client.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';
import 'package:simplio_app/data/http/services/password_reset_service.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/http/services/sign_in_service.dart';
import 'package:simplio_app/data/http/services/sign_up_service.dart';

class PublicHttpClient extends HttpClient {
  @override
  final ChopperClient client;

  PublicHttpClient._(this.client);

  PublicHttpClient.builder(
    String url,
  ) : this._(ChopperClient(
          baseUrl: Uri.parse(url),
          converter: JsonSerializableConverter({
            ...SignInService.converter(),
            ...SignUpService.converter(),
            ...RefreshTokenService.converter(),
            ...PasswordResetService.converter(),
          }),
          services: [
            SignInService.create(),
            SignUpService.create(),
            RefreshTokenService.create(),
            PasswordResetService.create(),
          ],
        ));
}
