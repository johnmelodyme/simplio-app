import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/account_wallet.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
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
                networkId: 60,
                address: '0x',
                preset: const AssetPreset(decimalPlaces: 19),
              )
            }),
            AssetWallet.builder(uuid: 'solana', assetId: 3, wallets: {
              501: NetworkWallet.builder(
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
}
