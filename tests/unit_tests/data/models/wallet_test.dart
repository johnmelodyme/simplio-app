import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:uuid/uuid.dart';

const _mnemonic = 'not your keys not your coins';

void main() {
  group(
    'LockableMnemonic:',
    () {
      final secret = Account.generateSecret();
      test(
        'locked mnemonic does not equal to its original value.',
        () {
          final m = LockableMnemonic.unlocked(mnemonic: _mnemonic);
          m.lock(secret.toString());
          expect(m.toString(), isNot(equals(_mnemonic)));
        },
      );

      test(
        'unlocked mnemonic does equal to its original value.',
        () {
          final m = LockableMnemonic.unlocked(mnemonic: _mnemonic);
          m.lock(secret.toString());
          final unlockedMnemonic = m.unlock(secret.toString());
          expect(unlockedMnemonic, equals(_mnemonic));
        },
      );
    },
  );

  group(
    'AccountWallet:',
    () {
      final mnemonic = LockableMnemonic.unlocked(mnemonic: _mnemonic);

      test(
        "is 'hd' type wallet",
        () {
          final accountWallet = AccountWallet.hd(
            uuid: const Uuid().v4(),
            accountId: '1',
            mnemonic: mnemonic,
          );

          expect(accountWallet.walletType, equals(AccountWalletTypes.hdWallet));
        },
      );

      test(
        'does not have any asset wallet by default.',
        () {
          final accountWallet = AccountWallet.hd(
            uuid: const Uuid().v4(),
            accountId: '1',
            mnemonic: mnemonic,
          );

          expect(accountWallet.wallets.length, equals(0));
        },
      );

      test(
        'has length 100 after added 100 asset wallets.',
        () {
          AccountWallet accountWallet = AccountWallet.hd(
            uuid: const Uuid().v4(),
            accountId: '1',
            mnemonic: mnemonic,
          );

          for (int i = 0; i < 100; i++) {
            accountWallet = accountWallet.addWallet(
              AssetWallet.builder(assetId: i),
            );
          }

          expect(accountWallet.wallets.length, equals(100));
        },
      );
    },
  );

  group(
    'AccountWallet updating wallets:',
    () {
      final accountWallet = AccountWallet.hd(
        uuid: const Uuid().v4(),
        accountId: 'test',
        mnemonic: LockableMnemonic.unlocked(mnemonic: _mnemonic),
        wallets: {
          1: AssetWallet.builder(uuid: 'bitcoin', assetId: 1),
          2: AssetWallet.builder(uuid: 'ethereum', assetId: 2),
          3: AssetWallet.builder(uuid: 'solana', assetId: 3),
          4: AssetWallet.builder(uuid: 'usdCoin', assetId: 4),
        },
      );

      test(
        'can find an asset wallet by uuid.',
        () {
          final res = accountWallet.findWallet('bitcoin');
          expect(res, isNotNull);
        },
      );

      test(
        "won't find an asset wallet with non existing uuid.",
        () {
          final res = accountWallet.findWallet('x');
          expect(res, isNull);
        },
      );

      test(
        'asset wallets which are updated from Iterable have equal length as original.',
        () {
          final updated = accountWallet.updateWalletsFromIterable([
            AssetWallet.builder(uuid: 'ethereum', assetId: 2, wallets: {
              60: NetworkWallet.builder(
                assetId: 2,
                networkId: 60,
                address: '0x',
                preset: const AssetPreset(decimalPlaces: 19),
              )
            }),
            AssetWallet.builder(uuid: 'solana', assetId: 3, wallets: {
              501: NetworkWallet.builder(
                assetId: 3,
                networkId: 501,
                address: '0x',
                preset: const AssetPreset(decimalPlaces: 19),
              )
            }),
          ]);

          expect(updated.wallets.length, equals(accountWallet.wallets.length));
        },
      );

      test(
        'asset wallets are updated from Iterable.',
        () {
          final updated = accountWallet.updateWalletsFromIterable([
            AssetWallet.builder(uuid: 'solana', assetId: 3, wallets: {
              501: NetworkWallet.builder(
                assetId: 3,
                networkId: 501,
                address: '0x',
                preset: const AssetPreset(decimalPlaces: 19),
              )
            }),
          ]);

          final res = updated.findWallet('solana')?.wallets.isNotEmpty ?? false;

          expect(res, isTrue);
        },
      );

      test(
        'only asset wallets which already exist are updated.',
        () {
          final updated = accountWallet.updateWalletsFromIterable([
            AssetWallet.builder(uuid: 'bitcoin', assetId: 1, wallets: {
              0: NetworkWallet.builder(
                assetId: 1,
                networkId: 0,
                address: '0x',
                preset: const AssetPreset(decimalPlaces: 8),
              )
            }),
            AssetWallet.builder(uuid: 'x', assetId: 1000),
          ]);

          final res = updated.wallets.where((w) => w.uuid == 'x').length;

          expect(res, isZero);
        },
      );
    },
  );

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
                assetId: 0,
                networkId: i,
                address: '',
                preset: const AssetPreset(decimalPlaces: 2),
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
        assetId: 2,
        networkId: 60,
        address: '0x',
        cryptoBalance: BigInt.zero,
        fiatBalance: 0,
        isEnabled: true,
        preset: const AssetPreset(decimalPlaces: 18),
      );
      final sol = NetworkWallet(
        uuid: 'solana',
        assetId: 5,
        networkId: 501,
        address: '0x',
        cryptoBalance: BigInt.zero,
        fiatBalance: 0,
        isEnabled: true,
        preset: const AssetPreset(decimalPlaces: 6),
      );
      final bnb = NetworkWallet(
        uuid: 'bnb',
        assetId: 10,
        networkId: 20000714,
        address: '0x',
        cryptoBalance: BigInt.zero,
        fiatBalance: 0,
        isEnabled: true,
        preset: const AssetPreset(decimalPlaces: 18),
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
            sol.copyWith(cryptoBalance: BigInt.from(4000)),
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
              assetId: 1,
              networkId: 0,
              address: '0x',
              cryptoBalance: BigInt.zero,
              fiatBalance: 0,
              isEnabled: false,
              preset: const AssetPreset(decimalPlaces: 8),
            ),
          ]);

          final res = updated.wallets.where((w) => w.uuid == 'x').length;

          expect(res, isZero);
        },
      );
    },
  );
}
