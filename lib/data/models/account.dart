import 'package:equatable/equatable.dart';
import 'package:simplio_app/data/mixins/aes_encryption_mixin.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';

const int securityAttemptsLimit = 6;

class Account extends Equatable {
  static String generateSecret() => Key.fromSecureRandom(keyByteSize).base64;

  final String id;
  final AccountType accountType;
  final LockableString secret;
  final SecurityLevel securityLevel;
  final int securityAttempts;
  final DateTime signedIn;
  // TODO - Think if account settings will hold information that will be sync with account service. In that case it should be restrucured and renamed. It is possible that the logic for relationship might be shipped to standalone hive box.
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
          id: "${const Uuid().v4()}.${DateTime.now().millisecondsSinceEpoch}",
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

enum AccountType {
  anonymous,
  registered,
}

enum SecurityLevel {
  none,
  pin,
}
