import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/providers/entities/auth_token_entity.dart';
import 'package:simplio_app/data/providers/helpers/storage_provider.dart';

class AuthorizeInterceptor extends RequestInterceptor {
  final StorageProvider<AuthTokenEntity> authTokenStorage;

  AuthorizeInterceptor({
    required this.authTokenStorage,
  });

  @override
  FutureOr<Request> onRequest(Request request) {
    final authToken = authTokenStorage.read();

    return request.copyWith(headers: {
      "Authorization": "${authToken.tokenType} ${authToken.accessToken}",
    });
  }
}
