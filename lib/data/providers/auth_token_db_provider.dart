import 'package:hive_flutter/adapters.dart';
import 'package:simplio_app/data/providers/entities/auth_token_entity.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/providers/helpers/storage_provider.dart';

class AuthTokenDbProvider extends BoxProvider<AuthTokenEntity>
    implements StorageProvider<AuthTokenEntity> {
  static final AuthTokenDbProvider _instance = AuthTokenDbProvider._();

  @override
  final String boxName = 'authTokenBox';

  AuthTokenDbProvider._();

  factory AuthTokenDbProvider() => _instance;

  @override
  void registerAdapters() {
    Hive.registerAdapter(AuthTokenEntityAdapter());
  }

  @override
  AuthTokenEntity read() {
    if (box.isNotEmpty) return box.values.first;
    throw Exception('Auth token not found.');
  }

  @override
  Future<void> write(AuthTokenEntity authToken) async {
    await box.clear();
    box.add(authToken);
  }
}
