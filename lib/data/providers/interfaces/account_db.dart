import 'package:simplio_app/data/models/account.dart';

abstract class AccountDb {
  Future<Account?> get(String id);
  Future<Account?> getLast();
  Future<Account> save(Account account);
}
