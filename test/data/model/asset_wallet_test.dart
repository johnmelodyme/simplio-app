import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';

void main() {
  group(
    'AssetWallet:',
    () {
      // final mnemonic = LockableMnemonic.value(mnemonic: _mnemonic);

      test(
        'does not have any network wallet by default.',
        () {
          final assetWallet = AssetWallet.builder(assetId: 0);
          expect(assetWallet.wallets.length, equals(0));
        },
      );

      test(
        'has length 100 after added 100 network wallets.',
        () {
          AssetWallet assetWallet = AssetWallet.builder(assetId: 0);

          for (var i = 0; i < 100; i++) {
            assetWallet = assetWallet.addWallet(
              NetworkWallet.builder(networkId: i, address: ''),
            );
          }

          expect(assetWallet.wallets.length, equals(100));
        },
      );
    },
  );
}
