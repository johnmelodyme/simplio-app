import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/providers/auth_token_db_provider.dart';
import 'package:simplio_app/data/providers/helpers/storage_provider.dart';

class AuthorizeInterceptor extends RequestInterceptor {
  final StorageProvider<AuthToken> authTokenStorage;

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
