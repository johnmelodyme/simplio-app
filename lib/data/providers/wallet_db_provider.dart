import 'package:hive/hive.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/providers/entities/wallet_entity.dart';
import 'package:simplio_app/data/providers/errors/provider_error.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/providers/interfaces/wallet_db.dart';
import 'package:simplio_app/data/providers/mappers/wallet_mapper.dart';

class WalletDbProvider extends BoxProvider<AccountWalletEntity>
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
    Hive.registerAdapter(NetworkWalletEntityAdapter());
    Hive.registerAdapter(AssetWalletEntityAdapter());
    Hive.registerAdapter(AccountWalletEntityAdapter());
  }

  @override
  Future<AccountWallet> save(AccountWallet accountWallet) async {
    try {
      await box.put(
        accountWallet.uuid,
        accountWallet.toEntity(),
      );

      return accountWallet;
    } catch (e) {
      throw ProviderError(
        code: ProviderErrorCodes.failedToSave,
        message: 'Saving Account wallet failed with error: $e.',
      );
    }
  }

  @override
  List<AccountWallet> getAll(String accountId) {
    try {
      return box.values
          .where((w) => w.accountId == accountId)
          .map(((a) => a.toModel()))
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
}
