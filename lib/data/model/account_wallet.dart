import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/lockable_string.dart';
import 'package:uuid/uuid.dart';

part 'account_wallet.g.dart';

class AccountWallet extends Equatable {
  final String uuid;
  final String accountId;
  final DateTime updatedAt;
  final LockableMnemonic mnemonic;
  final AccountWalletTypes walletType;
  final Map<int, AssetWallet> _wallets;

  const AccountWallet(
    this.uuid,
    this.accountId,
    this.updatedAt,
    this.mnemonic,
    this.walletType,
    this._wallets,
  );

  AccountWallet.hd({
    String? uuid,
    required String accountId,
    DateTime? updatedAt,
    String? name,
    required LockableMnemonic mnemonic,
    Map<int, AssetWallet>? wallets,
  }) : this(
          uuid ?? const Uuid().v4(),
          accountId,
          updatedAt ?? DateTime.now(),
          mnemonic,
          AccountWalletTypes.hdWallet,
          wallets ?? const {},
        );

  List<AssetWallet> get wallets => _wallets.values.toList();

  @override
  List<Object?> get props => [
        uuid,
        accountId,
        updatedAt,
        walletType,
        wallets,
      ];

  AssetWallet? getWallet(int assetId) {
    return _wallets[assetId];
  }

  AccountWallet addWallet(AssetWallet wallet) {
    final Map<int, AssetWallet> m = Map.from(_wallets);
    m[wallet.assetId] = wallet;
    return copyWith(wallets: m);
  }

  bool containsWallet(int assetId) {
    return _wallets.containsKey(assetId);
  }

  AccountWallet copyWith({
    DateTime? updatedAt,
    LockableMnemonic? mnemonic,
    Map<int, AssetWallet>? wallets,
  }) {
    return AccountWallet(
      uuid,
      accountId,
      updatedAt ?? this.updatedAt,
      mnemonic ?? this.mnemonic,
      walletType,
      wallets ?? _wallets,
    );
  }
}

class LockableMnemonic {
  final LockableString value;
  final bool isBackedUp;
  final bool isImported;

  LockableMnemonic({
    required this.value,
    required this.isBackedUp,
    required this.isImported,
  }) : assert(
          isImported ? isBackedUp == isImported : true,
          'If mnemonic is imported, it is considered also backed up',
        );
  LockableMnemonic.locked({
    required String base64Mnemonic,
    required bool isBackedUp,
    required bool isImported,
  }) : this(
          value: LockableString.locked(base64String: base64Mnemonic),
          isBackedUp: isBackedUp,
          isImported: isImported,
        );

  LockableMnemonic.unlocked({
    required String mnemonic,
    bool? isBackedUp,
    bool? isImported,
  }) : this(
          value: LockableString.unlocked(value: mnemonic),
          isBackedUp: isBackedUp ?? false,
          isImported: isImported ?? false,
        );

  LockableMnemonic.imported({
    required String mnemonic,
  }) : this(
          value: LockableString.unlocked(value: mnemonic),
          isBackedUp: true,
          isImported: true,
        );

  String unlock(String key) {
    return value.unlock(key);
  }

  LockableMnemonic lock(String key) {
    value.lock(key);
    return this;
  }

  @override
  String toString() {
    return value.toString();
  }
}

@HiveType(typeId: 31)
enum AccountWalletTypes {
  @HiveField(0)
  hdWallet,
}

@HiveType(typeId: 3)
class AccountWalletLocal extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String accountId;

  @HiveField(2)
  final DateTime updatedAt;

  @HiveField(3)
  final String mnemonic;

  @HiveField(4)
  final bool isImported;

  @HiveField(5)
  final bool isBackedUp;

  @HiveField(6)
  final AccountWalletTypes walletType;

  @HiveField(7)
  final List<AssetWalletLocal> wallets;

  AccountWalletLocal({
    required this.uuid,
    required this.accountId,
    required this.updatedAt,
    required this.mnemonic,
    required this.isImported,
    required this.isBackedUp,
    required this.walletType,
    required this.wallets,
  });
}
