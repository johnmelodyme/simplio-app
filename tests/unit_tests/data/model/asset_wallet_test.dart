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

          for (int i = 0; i < 100; i++) {
            assetWallet = assetWallet.addWallet(
              NetworkWallet.builder(
                networkId: i,
                address: '',
                decimalPlaces: 2,
              ),
            );
          }

          expect(assetWallet.wallets.length, equals(100));
        },
      );
    },
  );

  group(
    'AssetWallet updating wallets:',
    () {
      final eth = NetworkWallet(
        uuid: 'ethereum',
        contractAddress: '0x',
        networkId: 60,
        address: '0x',
        decimalPlaces: 16,
        balance: BigInt.zero,
        fiatBalance: 0,
        isEnabled: true,
      );
      final sol = NetworkWallet(
        uuid: 'solana',
        contractAddress: '0x',
        networkId: 501,
        address: '0x',
        decimalPlaces: 9,
        balance: BigInt.zero,
        fiatBalance: 0,
        isEnabled: true,
      );
      final bnb = NetworkWallet(
        uuid: 'bnb',
        contractAddress: '0x',
        networkId: 20000714,
        address: '0x',
        decimalPlaces: 9,
        balance: BigInt.zero,
        fiatBalance: 0,
        isEnabled: true,
      );

      final assetWallet = AssetWallet.builder(
        assetId: 100,
        wallets: {
          60: eth,
          501: sol,
          20000714: bnb,
        },
      );

      test(
        'can find a network wallet by uuid.',
        () {
          final res = assetWallet.findWallet(eth.uuid);
          expect(res, isNotNull);
        },
      );

      test(
        "won't find a network wallet with non existing uuid.",
        () {
          final res = assetWallet.findWallet('x');
          expect(res, isNull);
        },
      );

      test(
        'network wallets which are updated from Iterable have equal length as original.',
        () {
          final updated = assetWallet.updateWalletsFromIterable([
            sol.copyWith(balance: BigInt.from(4000)),
          ]);

          expect(updated.wallets.length, equals(assetWallet.wallets.length));
        },
      );

      test(
        'network wallets are updated from Iterable.',
        () {
          final updated = assetWallet.updateWalletsFromIterable([
            sol.copyWith(isEnabled: false),
          ]);

          final res = updated.findWallet('solana')?.isEnabled ?? true;

          expect(res, isFalse);
        },
      );

      test(
        'only network wallets which already exist are updated.',
        () {
          final updated = assetWallet.updateWalletsFromIterable([
            sol.copyWith(isEnabled: false),
            NetworkWallet(
              uuid: 'x',
              contractAddress: '0x',
              networkId: 0,
              address: '0x',
              decimalPlaces: 8,
              balance: BigInt.zero,
              fiatBalance: 0,
              isEnabled: false,
            ),
          ]);

          final res = updated.wallets.where((w) => w.uuid == 'x').length;

          expect(res, isZero);
        },
      );
    },
  );
}
