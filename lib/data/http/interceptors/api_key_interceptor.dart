import 'dart:async';

import 'package:chopper/chopper.dart';

class ApiKeyInterceptor extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    return request.copyWith(parameters: {
      ...request.parameters,
      "code": const String.fromEnvironment('API_KEY'),
    });
  }
}
