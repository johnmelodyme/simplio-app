import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:simplio_app/data/mixins/aes_encryption_mixin.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/data/model/lockable_string.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';

part 'account.g.dart';

const int securityAttemptsLimit = 6;

class Account extends Equatable {
  static String generateSecret() => Key.fromSecureRandom(keyByteSize).base64;

  final String id;
  final AccountType accountType;
  final LockableString secret;
  final SecurityLevel securityLevel;
  final int securityAttempts;
  final DateTime signedIn;
  final AccountSettings settings;

  const Account({
    required this.id,
    required this.accountType,
    required this.secret,
    required this.securityLevel,
    required this.securityAttempts,
    required this.signedIn,
    required this.settings,
  })  : assert(id.length > 0),
        assert(securityAttempts >= 0);

  Account.registered({
    required String id,
    SecurityLevel? securityLevel,
    required DateTime signedIn,
    AccountSettings settings = const AccountSettings.builder(),
  }) : this(
          id: id,
          accountType: AccountType.registered,
          secret: LockableString.unlocked(value: generateSecret()),
          securityLevel: securityLevel ?? SecurityLevel.none,
          securityAttempts: securityAttemptsLimit,
          signedIn: signedIn,
          settings: settings,
        );

  Account.anonymous()
      : this(
          id: "${const Uuid().v4()}.${DateTime.now().microsecondsSinceEpoch}",
          accountType: AccountType.anonymous,
          secret: LockableString.unlocked(value: generateSecret()),
          securityLevel: SecurityLevel.none,
          securityAttempts: securityAttemptsLimit,
          signedIn: DateTime.now(),
          settings: const AccountSettings.builder(),
        );

  Account copyWith({
    LockableString? secret,
    SecurityLevel? securityLevel,
    int? securityAttempts,
    DateTime? signedIn,
    AccountSettings? settings,
  }) {
    return Account(
      id: id,
      accountType: accountType,
      secret: secret ?? this.secret,
      securityLevel: securityLevel ?? this.securityLevel,
      securityAttempts: securityAttempts ?? this.securityAttempts,
      signedIn: signedIn ?? this.signedIn,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        accountType,
        secret,
        securityLevel,
        securityAttempts,
        signedIn,
        settings,
      ];
}

@HiveType(typeId: 11)
enum AccountType {
  @HiveField(0)
  anonymous,

  @HiveField(1)
  registered,
}

@HiveType(typeId: 12)
enum SecurityLevel {
  @HiveField(0)
  none,

  @HiveField(1)
  pin,
}

@HiveType(typeId: 1)
class AccountLocal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final AccountType accountType;

  @HiveField(2)
  final String secret;

  @HiveField(3)
  final SecurityLevel securityLevel;

  @HiveField(4)
  final int securityAttempts;

  @HiveField(5)
  final DateTime signedIn;

  @HiveField(6)
  final AccountSettingsLocal settings;

  AccountLocal({
    required this.id,
    required this.accountType,
    required this.secret,
    required this.securityLevel,
    required this.securityAttempts,
    required this.signedIn,
    required this.settings,
  });
}
