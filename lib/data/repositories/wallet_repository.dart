import 'package:simplio_app/data/model/account_wallet.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:sio_core_light/sio_core_light.dart' as sio;

class WalletRepository {
  final WalletDb _walletDb;

  late String _walletId;
  late HDWallet _wallet;

  WalletRepository._(
    this._walletDb,
  );

  WalletRepository.builder({
    required WalletDb walletDb,
  }) : this._(
          walletDb,
        );

  Future<AccountWallet> loadAccountWallet(
    String accountId, {
    required String key,
  }) async {
    final AccountWallet w = _walletDb.getLast(accountId) ??
        await addAccountWallet(
          accountId,
          key: key,
        );

    final mnemonic = w.mnemonic.unlock(key);

    /// Initialize [HDWallet] in repository.
    _walletId = w.uuid;
    _wallet = HDWallet.createWithMnemonic(mnemonic);

    return w;
  }

  Future<AccountWallet> addAccountWallet(
    String accountId, {
    required key,
    String? name,
    String? mnemonic,
  }) async {
    final isProvided = mnemonic != null;
    final m = LockableMnemonic.unlocked(
      mnemonic: mnemonic ?? sio.Mnemonic().generate,
      isBackedUp: isProvided,
      isImported: isProvided,
    );
    m.lock(key);

    return _walletDb.save(AccountWallet.hd(
      accountId: accountId,
      mnemonic: m,
    ));
  }

  Future<AccountWallet> addNetworkWallet(
    AccountWallet accountWallet, {
    required NetworkData data,
  }) async {
    _checkInitializedAccountWallet(accountWallet.uuid);

    /// Add [NetworkWallet] for already existing [AssetWallet].
    final assetWallet = accountWallet.getWallet(data.assetId);
    if (assetWallet != null) {
      final w = _addNetworkWallet(assetWallet, data: data);
      return _walletDb.save(accountWallet.addWallet(w));
    }

    /// Build a new [AssetWallet] and immediately add [NetworkWallet] to it.
    final w = _addNetworkWallet(
      AssetWallet.builder(assetId: data.assetId),
      data: data,
    );
    return _walletDb.save(accountWallet.addWallet(w));
  }

  AssetWallet _addNetworkWallet(
    AssetWallet wallet, {
    required NetworkData data,
  }) {
    if (wallet.containsWallet(data.networkId)) return wallet.copyWith();

    return wallet.addWallet(NetworkWallet.builder(
      networkId: data.networkId,
      address: _wallet.getAddressForCoin(data.networkId),
      contractAddress: data.contractAddress,
    ));
  }

  String getMnemonic() {
    return _wallet.mnemonic();
  }

  void _checkInitializedAccountWallet(String accountWalletId) {
    if (_walletId == accountWalletId) return;
    throw Exception("Account wallet '$accountWalletId}' is not initialized");
  }
}

abstract class WalletDb {
  Future<AccountWallet> save(AccountWallet accountWallet);
  List<AccountWallet> getAll(String accountId);
  AccountWallet? getLast(String accountId);
}
