import 'package:hive_flutter/adapters.dart';
import 'package:simplio_app/data/model/auth_token.dart';
import 'package:simplio_app/data/providers/box_provider.dart';
import 'package:simplio_app/data/providers/storage_provider.dart';

class AuthTokenDbProvider extends BoxProvider<AuthToken>
    implements StorageProvider<AuthToken> {
  static final AuthTokenDbProvider _instance = AuthTokenDbProvider._();

  @override
  final String boxName = 'authTokenBox';

  AuthTokenDbProvider._();

  factory AuthTokenDbProvider() => _instance;

  @override
  void registerAdapters() {
    Hive.registerAdapter(AuthTokenAdapter());
  }

  @override
  AuthToken read() {
    if (box.isNotEmpty) return box.values.first;
    throw Exception('Auth token not found.');
  }

  @override
  Future<void> write(AuthToken authToken) async {
    await box.clear();
    box.add(authToken);
  }
}
