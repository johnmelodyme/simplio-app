import 'package:simplio_app/data/http/services/wallet_inventory_service.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

extension AccountWalletBalanceMapper on AccountWallet {
  AccountWalletBalanceRequest toAccountBalanceRequest({
    required String currency,
  }) {
    return AccountWalletBalanceRequest(
      currency: currency,
      assets: wallets.map((asset) {
        return AccountWalletAssetItemRequest(
          assetId: asset.assetId,
          networks: asset.wallets.map((network) {
            return AccountWalletNetworkItemRequest(
              networkId: network.networkId,
              cryptoBalance: network.cryptoBalance.toString(),
              walletAddress: network.walletAddress,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  AccountWallet fromAccountWalletBalanceResponse(
    AccountWalletBalanceResponse response,
  ) {
    return updateWalletsFromIterable(
        response.assets.fold<List<AssetWallet>>([], (acc, curr) {
      final assetWallet = getWallet(curr.assetId);
      if (assetWallet == null) return acc;

      return acc
        ..add(assetWallet.updateWalletsFromIterable(
            curr.networks.fold<List<NetworkWallet>>([], (acc, curr) {
          final netWallet = assetWallet.getWallet(curr.networkId);
          if (netWallet == null) return acc;

          return acc
            ..add(netWallet.copyWith(
              fiatBalance: BigDecimal.fromDouble(
                curr.fiatBalance,
                precision: netWallet.preset.decimalPlaces,
              ),
              cryptoBalance: BigDecimal.fromBigInt(
                BigInt.parse(curr.cryptoBalance),
                precision: netWallet.preset.decimalPlaces,
              ),
            ));
        })));
    }));
  }
}
