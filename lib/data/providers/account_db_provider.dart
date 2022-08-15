import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/data/model/lockable_string.dart';
import 'package:simplio_app/data/providers/box_provider.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';

class AccountDbProvider extends BoxProvider<AccountLocal> implements AccountDb {
  static final AccountDbProvider _instance = AccountDbProvider._();

  @override
  final String boxName = 'accountBox';

  AccountDbProvider._();

  factory AccountDbProvider() {
    return _instance;
  }

  @override
  void registerAdapters() {
    Hive.registerAdapter(AccountLocalAdapter());
    Hive.registerAdapter(AccountTypeAdapter());
    Hive.registerAdapter(SecurityLevelAdapter());
    Hive.registerAdapter(AccountSettingsLocalAdapter());
  }

  @override
  Account? get(String id) {
    try {
      final AccountLocal? account = box.get(id);
      return account != null ? _mapAccountFrom(account) : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Account> save(Account account) async {
    await box.put(account.id, _mapAccountTo(account));
    return account;
  }

  @override
  Account? getLast() {
    try {
      final localAccount = box.values.reduce(
        (acc, curr) => acc.signedIn.isAfter(curr.signedIn) ? acc : curr,
      );

      final isZero = localAccount.signedIn.isAtSameMomentAs(
        DateTime.fromMillisecondsSinceEpoch(0),
      );
      if (isZero) return null;

      return _mapAccountFrom(localAccount);
    } catch (_) {
      return null;
    }
  }

  AccountLocal _mapAccountTo(Account account) {
    return AccountLocal(
      id: account.id,
      accountType: account.accountType,
      secret: account.secret.toString(),
      securityLevel: account.securityLevel,
      securityAttempts: account.securityAttempts,
      signedIn: account.signedIn,
      settings: _mapAccountSettingsTo(account.settings),
    );
  }

  Account _mapAccountFrom(AccountLocal local) {
    return Account(
      id: local.id,
      accountType: local.accountType,
      secret: LockableString.locked(base64String: local.secret),
      securityLevel: local.securityLevel,
      securityAttempts: local.securityAttempts,
      signedIn: local.signedIn,
      settings: _mapAccountSettingsFrom(local.settings),
    );
  }

  AccountSettings _mapAccountSettingsFrom(AccountSettingsLocal local) {
    return AccountSettings(
      themeMode: ThemeMode.values[local.themeMode],
      locale: Locale(local.languageCode),
    );
  }

  AccountSettingsLocal _mapAccountSettingsTo(AccountSettings settings) {
    return AccountSettingsLocal(
      themeMode: settings.themeMode.index,
      languageCode: settings.locale.languageCode,
    );
  }
}
