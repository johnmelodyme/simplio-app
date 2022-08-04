import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/model/auth_token.dart';
import 'package:simplio_app/data/providers/storage_provider.dart';

class AuthorizeInterceptor extends RequestInterceptor {
  final StorageProvider<AuthToken> authTokenStorage;

  AuthorizeInterceptor({
    required this.authTokenStorage,
  });

  @override
  FutureOr<Request> onRequest(Request request) {
    final authToken = authTokenStorage.get();

    return request.copyWith(headers: {
      "Authorization": "${authToken.tokenType} ${authToken.accessToken}",
    });
  }
}
