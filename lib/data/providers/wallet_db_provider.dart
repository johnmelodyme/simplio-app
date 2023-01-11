import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/helpers/lockable.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';

part 'wallet_db_provider.g.dart';

class WalletDbProvider extends BoxProvider<AccountWalletLocal>
    implements WalletDb {
  static final WalletDbProvider _instance = WalletDbProvider._();

  @override
  final String boxName = 'walletBox';

  WalletDbProvider._();

  factory WalletDbProvider() {
    return _instance;
  }

  @override
  void registerAdapters() {
    Hive.registerAdapter(NetworkWalletLocalAdapter());
    Hive.registerAdapter(AssetWalletLocalAdapter());
    Hive.registerAdapter(AccountWalletLocalAdapter());
  }

  @override
  Future<AccountWallet> save(AccountWallet accountWallet) async {
    await box.put(accountWallet.uuid, _mapAccountWalletTo(accountWallet));
    return accountWallet;
  }

  @override
  List<AccountWallet> getAll(String accountId) {
    try {
      return box.values
          .where((w) => w.accountId == accountId)
          .map(_mapAccountWalletFrom)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  AccountWallet? getLast(String accountId) {
    try {
      final accountWallets = getAll(accountId);
      return accountWallets.reduce(
        (acc, curr) => acc.updatedAt.isAfter(curr.updatedAt) ? acc : curr,
      );
    } catch (_) {
      return null;
    }
  }

  AccountWalletLocal _mapAccountWalletTo(AccountWallet wallet) {
    return AccountWalletLocal(
      uuid: wallet.uuid,
      accountId: wallet.accountId,
      updatedAt: wallet.updatedAt,
      mnemonic: wallet.mnemonic.toString(),
      isBackedUp: wallet.mnemonic.isBackedUp,
      isImported: wallet.mnemonic.isImported,
      walletType: wallet.walletType.index,
      wallets: wallet.wallets.map(_mapAssetWalletTo).toList(),
    );
  }

  AssetWalletLocal _mapAssetWalletTo(AssetWallet wallet) {
    return AssetWalletLocal(
      uuid: wallet.uuid,
      assetId: wallet.assetId,
      wallets: wallet.wallets.map(_mapNetworkWalletTo).toList(),
    );
  }

  NetworkWalletLocal _mapNetworkWalletTo(NetworkWallet wallet) {
    return NetworkWalletLocal(
      uuid: wallet.uuid,
      networkId: wallet.networkId,
      address: wallet.address,
      balance: wallet.balance,
      isEnabled: wallet.isEnabled,
      fiatBalance: wallet.fiatBalance,
    );
  }

  AccountWallet _mapAccountWalletFrom(AccountWalletLocal local) {
    return AccountWallet(
      local.uuid,
      local.accountId,
      local.updatedAt,
      LockableMnemonic.locked(
        base64Mnemonic: local.mnemonic,
        isImported: local.isImported,
        isBackedUp: local.isBackedUp,
      ),
      AccountWalletTypes.values[local.walletType],
      Map.fromEntries(local.wallets.map(
        (e) => MapEntry(
          e.assetId,
          _mapAssetWalletFrom(e),
        ),
      )),
    );
  }

  AssetWallet _mapAssetWalletFrom(AssetWalletLocal local) {
    return AssetWallet(
      local.uuid,
      local.assetId,
      Map.fromEntries(local.wallets.map(
        (e) => MapEntry(
          e.networkId,
          _mapNetworkWalletFrom(e, assetId: local.assetId),
        ),
      )),
    );
  }

  NetworkWallet _mapNetworkWalletFrom(
    NetworkWalletLocal local, {
    required int assetId,
  }) {
    return NetworkWallet(
      uuid: local.uuid,
      networkId: local.networkId,
      address: local.address,
      balance: local.balance,
      isEnabled: local.isEnabled,
      fiatBalance: local.fiatBalance,
      preset: NetworkWallet.makePreset(
        assetId: assetId,
        networkId: local.networkId,
      ),
    );
  }
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
  final int walletType;

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

@HiveType(typeId: 4)
class AssetWalletLocal extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int assetId;

  @HiveField(2)
  final List<NetworkWalletLocal> wallets;

  AssetWalletLocal({
    required this.uuid,
    required this.assetId,
    required this.wallets,
  });
}

@HiveType(typeId: 5)
class NetworkWalletLocal extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int networkId;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final BigInt balance;

  @HiveField(4)
  final bool isEnabled;

  @HiveField(5)
  final double fiatBalance;

  NetworkWalletLocal({
    required this.uuid,
    required this.networkId,
    required this.address,
    required this.balance,
    required this.isEnabled,
    required this.fiatBalance,
  });
}
