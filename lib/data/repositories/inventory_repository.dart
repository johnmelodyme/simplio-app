import 'package:flutter/foundation.dart';
import 'package:simplio_app/data/http/services/inventory_service.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';

// TODO - Refreshing wallet balances should be mode to the realated domain.
class InventoryRepository {
  final WalletDb _walletDb;
  final InventoryService _inventoryService;

  InventoryRepository._(
    this._walletDb,
    this._inventoryService,
  );

  InventoryRepository({
    required WalletDb walletDb,
    required InventoryService inventoryService,
  }) : this._(
          walletDb,
          inventoryService,
        );

  Future<AccountWallet> refreshAccountWalletBalance({
    required AccountWallet accountWallet,
    required String fiatAssetId,
    bool save = true,
  }) async {
    try {
      final List<UserWallet> userWallets = [];
      for (final wallet in accountWallet.wallets) {
        final newUserWallets = wallet.wallets.map(
          (networkWallet) => UserWallet(
            address: networkWallet.address,
            assetsIds: [wallet.assetId],
            networkId: networkWallet.networkId,
          ),
        );

        for (final newUserWallet in newUserWallets) {
          if (userWallets.any((userWallet) =>
              userWallet.networkId == newUserWallet.networkId)) {
            userWallets
                .firstWhere((userWallet) =>
                    userWallet.networkId == newUserWallet.networkId)
                .assetsIds
                .add(wallet.assetId);
          } else {
            userWallets.add(newUserWallet);
          }
        }
      }
      final BalanceBody body =
          BalanceBody(userWallets: userWallets, fiatAssetId: fiatAssetId);

      final res = await _inventoryService.balance(body);
      if (res.body != null) {
        List<AssetWallet> updatedAssetWallets = [];
        for (final assetWallet in accountWallet.wallets) {
          final List<NetworkWallet> networkWallets = [];
          for (final networkWallet in assetWallet.wallets) {
            final asset = res.body!.wallets
                .firstWhere(
                    (wallet) => wallet.networkId == networkWallet.networkId)
                .assets
                .firstWhere((a) => a.assetId == assetWallet.assetId);
            final updatedNetworkWallet = networkWallet.copyWith(
                balance: BigInt.parse(asset.balance),
                fiatBalance: asset.fiatValue);
            networkWallets.add(updatedNetworkWallet);
          }
          updatedAssetWallets
              .add(assetWallet.updateWalletsFromIterable(networkWallets));
        }

        final AccountWallet updatedAccountWallet =
            accountWallet.updateWalletsFromIterable(updatedAssetWallets);

        if (save) await _walletDb.save(updatedAccountWallet);

        return updatedAccountWallet;
      }
      throw Exception('BalanceBody is null');
    } catch (e) {
      debugPrint(e.toString());
      return accountWallet;
    }
  }
}
