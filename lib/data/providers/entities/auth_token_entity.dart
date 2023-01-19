import 'package:hive/hive.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';

part 'auth_token_entity.g.dart';

@HiveType(typeId: 7)
class AuthTokenEntity extends Entity {
  @HiveField(0)
  final String refreshToken;

  @HiveField(1)
  final String accessToken;

  @HiveField(2)
  final String tokenType;

  AuthTokenEntity({
    required this.refreshToken,
    required this.accessToken,
    required this.tokenType,
  });
}
