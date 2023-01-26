import 'package:chopper/chopper.dart';

class HttpClient {
  final ChopperClient _client;
  final Map<Type, HttpApi> _clients;

  const HttpClient._(
    this._client,
    this._clients,
  );

  factory HttpClient({
    required String url,
    Iterable<ChopperService> services = const [],
    Converter? converter,
    ErrorConverter? errorConverter,
    Iterable<dynamic> interceptors = const [],
    Authenticator? authenticator,
    Iterable<HttpApi> apis = const [],
  }) {
    return HttpClient._(
      ChopperClient(
        baseUrl: Uri.parse(url),
        services: services,
        converter: converter,
        interceptors: interceptors,
        authenticator: authenticator,
        errorConverter: errorConverter,
      ),
      apis.fold({}, (acc, curr) {
        acc[curr.runtimeType] = curr;
        return acc;
      }),
    );
  }

  T api<T extends HttpApi>() {
    final api = _clients[T];
    if (api == null) {
      throw Exception('Api not found');
    }

    final serviceType = api.serviceType;
    if (serviceType == dynamic && serviceType is! ChopperService) {
      throw Exception('Api service type is not ChopperService');
    }

    return api as T;
  }

  void registerApi(HttpApi api) {
    _clients[api.runtimeType] = api..registerService(_client);
  }
}

class HttpApi<T extends ChopperService> {
  late final T service;
  final serviceType = T;

  HttpApi();

  void registerService(ChopperClient client) {
    service = client.getService<T>();
  }
}
