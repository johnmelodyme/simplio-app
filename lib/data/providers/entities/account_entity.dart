import 'package:hive/hive.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';

part 'account_entity.g.dart';

@HiveType(typeId: 1)
class AccountEntity extends Entity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int accountType;

  @HiveField(2)
  final String secret;

  @HiveField(3)
  final int securityLevel;

  @HiveField(4)
  final int securityAttempts;

  @HiveField(5)
  final DateTime signedIn;

  @HiveField(6)
  final AccountSettingsEntity settings;

  AccountEntity({
    required this.id,
    required this.accountType,
    required this.secret,
    required this.securityLevel,
    required this.securityAttempts,
    required this.signedIn,
    required this.settings,
  });
}

@HiveType(typeId: 2)
class AccountSettingsEntity extends Entity {
  @HiveField(0)
  final int themeMode;
  @HiveField(1)
  final String languageCode;

  AccountSettingsEntity({
    required this.themeMode,
    required this.languageCode,
  });
}
