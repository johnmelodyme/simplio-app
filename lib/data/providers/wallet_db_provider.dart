import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/account_wallet.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/data/providers/box_provider.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';

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
    Hive.registerAdapter(AccountWalletTypesAdapter());
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
          .map((w) => _mapAccountWalletFrom(w))
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
      walletType: wallet.walletType,
      wallets: wallet.wallets.map((w) => _mapAssetWalletTo(w)).toList(),
    );
  }

  AssetWalletLocal _mapAssetWalletTo(AssetWallet wallet) {
    return AssetWalletLocal(
      uuid: wallet.uuid,
      assetId: wallet.assetId,
      isEnabled: wallet.isEnabled,
      wallets: wallet.wallets.map((w) => _mapNetworkWalletTo(w)).toList(),
    );
  }

  NetworkWalletLocal _mapNetworkWalletTo(NetworkWallet wallet) {
    return NetworkWalletLocal(
      uuid: wallet.uuid,
      networkId: wallet.networkId,
      address: wallet.address,
      contractAddress: wallet.contractAddress,
      balance: wallet.balance,
      isEnabled: wallet.isEnabled,
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
      local.walletType,
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
      local.isEnabled,
      Map.fromEntries(local.wallets.map(
        (e) => MapEntry(
          e.networkId,
          _mapNetworkWalletFrom(e),
        ),
      )),
    );
  }

  NetworkWallet _mapNetworkWalletFrom(NetworkWalletLocal local) {
    return NetworkWallet(
      uuid: local.uuid,
      networkId: local.networkId,
      address: local.address,
      balance: local.balance,
      isEnabled: local.isEnabled,
    );
  }
}
