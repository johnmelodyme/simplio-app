import 'package:hive/hive.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';

part 'wallet_entity.g.dart';

@HiveType(typeId: 3)
class AccountWalletEntity extends Entity {
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
  final int walletType;

  @HiveField(7)
  final List<AssetWalletEntity> wallets;

  AccountWalletEntity({
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

@HiveType(typeId: 4)
class AssetWalletEntity extends Entity {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int assetId;

  @HiveField(2)
  final List<NetworkWalletEntity> wallets;

  AssetWalletEntity({
    required this.uuid,
    required this.assetId,
    required this.wallets,
  });
}

@HiveType(typeId: 5)
class NetworkWalletEntity extends Entity {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int assetId;

  @HiveField(2)
  final int networkId;

  @HiveField(3)
  final String walletAddress;

  @HiveField(4)
  final BigInt cryptoBalance;

  @HiveField(5)
  final BigInt fiatBalance;

  @HiveField(6)
  final bool isEnabled;

  NetworkWalletEntity({
    required this.uuid,
    required this.assetId,
    required this.networkId,
    required this.walletAddress,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.isEnabled,
  });
}
