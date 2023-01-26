import 'package:hive/hive.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/providers/entities/account_entity.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/providers/interfaces/account_db.dart';
import 'package:simplio_app/data/providers/mappers/account_mapper.dart';

class AccountDbProvider extends BoxProvider<AccountEntity>
    implements AccountDb {
  static final AccountDbProvider _instance = AccountDbProvider._();

  @override
  final String boxName = 'accountBox';

  AccountDbProvider._();

  factory AccountDbProvider() {
    return _instance;
  }

  @override
  void registerAdapters() {
    Hive.registerAdapter(AccountEntityAdapter());
    Hive.registerAdapter(AccountSettingsEntityAdapter());
  }

  @override
  Future<Account?> get(String id) async {
    try {
      final AccountEntity? account = box.get(id);
      return account?.toModel();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Account> save(Account account) async {
    await box.put(
      account.id,
      account.toEntity(),
    );
    return account;
  }

  @override
  Future<Account?> getLast() async {
    try {
      final localAccount = box.values.reduce(
        (acc, curr) => acc.signedIn.isAfter(curr.signedIn) ? acc : curr,
      );

      final isZero = localAccount.signedIn.isAtSameMomentAs(
        DateTime.fromMillisecondsSinceEpoch(0),
      );
      if (isZero) return null;

      return localAccount.toModel();
    } catch (_) {
      return null;
    }
  }
}
