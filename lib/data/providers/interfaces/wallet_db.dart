import 'package:simplio_app/data/models/wallet.dart';

abstract class WalletDb {
  Future<AccountWallet> save(AccountWallet accountWallet);
  List<AccountWallet> getAll(String accountId);
  AccountWallet? getLast(String accountId);
}
