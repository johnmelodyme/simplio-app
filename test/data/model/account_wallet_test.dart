import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/account_wallet.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';

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
            accountId: '1',
            mnemonic: mnemonic,
          );

          for (var i = 0; i < 100; i++) {
            accountWallet = accountWallet.addWallet(
              AssetWallet.builder(assetId: i),
            );
          }

          expect(accountWallet.wallets.length, equals(100));
        },
      );
    },
  );
}
