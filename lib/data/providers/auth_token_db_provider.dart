import 'package:hive_flutter/adapters.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/providers/helpers/storage_provider.dart';

part 'auth_token_db_provider.g.dart';

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

@HiveType(typeId: 7)
class AuthToken extends HiveObject {
  @HiveField(0)
  final String refreshToken;

  @HiveField(1)
  final String accessToken;

  @HiveField(2)
  final String tokenType;

  AuthToken({
    required this.refreshToken,
    required this.accessToken,
    required this.tokenType,
  });
}
