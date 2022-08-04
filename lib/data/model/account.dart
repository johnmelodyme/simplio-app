import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/data/model/account_wallet.dart';
import 'package:simplio_app/data/model/lockable_string.dart';
import 'package:uuid/uuid.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

part 'account.g.dart';

const int securityAttemptsLimit = 6;

class Account extends Equatable {
  final String id;
  final AccountType accountType;
  final LockableString secret;
  final SecurityLevel securityLevel;
  final int securityAttempts;
  final DateTime signedIn;
  final AccountSettings settings;
  final List<AccountWallet> wallets;

  const Account(
    this.id,
    this.accountType,
    this.secret,
    this.securityLevel,
    this.securityAttempts,
    this.signedIn,
    this.settings,
    this.wallets,
  )   : assert(id.length > 0),
        assert(securityAttempts >= 0);

  const Account.registered({
    required String id,
    required LockableString secret,
    SecurityLevel? securityLevel,
    required DateTime signedIn,
    AccountSettings settings = const AccountSettings.preset(),
    List<AccountWallet> wallets = const <AccountWallet>[],
  }) : this(
          id,
          AccountType.registered,
          secret,
          securityLevel ?? SecurityLevel.none,
          securityAttemptsLimit,
          signedIn,
          settings,
          wallets,
        );

  Account.anonymous()
      : this(
          "${const Uuid().v4()}.${DateTime.now().microsecondsSinceEpoch}",
          AccountType.anonymous,
          LockableString.generate(),
          SecurityLevel.none,
          securityAttemptsLimit,
          DateTime.now(),
          const AccountSettings.preset(),
          const <AccountWallet>[],
        );

  Account copyWith({
    LockableString? secret,
    SecurityLevel? securityLevel,
    int? securityAttempts,
    DateTime? signedIn,
    AccountSettings? settings,
    List<AccountWallet>? wallets,
  }) {
    return Account(
      id,
      accountType,
      secret ?? this.secret,
      securityLevel ?? this.securityLevel,
      securityAttempts ?? this.securityAttempts,
      signedIn ?? this.signedIn,
      settings ?? this.settings,
      wallets ?? this.wallets,
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
      ];

  AccountWallet? get accountWallet {
    if (wallets.isNotEmpty) return wallets.first;
    return null;
  }

  HDWallet? get trustWallet {
    String mnemonic = wallets
        .firstWhere(
            (element) => element.walletType == AccountWalletTypes.hdWallet)
        .seed
        .toString();

    return HDWallet.createWithMnemonic(mnemonic);
  }
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

  @HiveField(7)
  final List<AccountWalletLocal> wallets;

  AccountLocal({
    required this.id,
    required this.accountType,
    required this.secret,
    required this.securityLevel,
    required this.securityAttempts,
    required this.signedIn,
    required this.settings,
    required this.wallets,
  });
}
