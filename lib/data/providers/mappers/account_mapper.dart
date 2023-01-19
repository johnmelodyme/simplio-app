import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/providers/entities/account_entity.dart';
import 'package:simplio_app/data/providers/helpers/mapper.dart';

class AccountMapper extends Mapper<Account, AccountEntity> {
  final AccountSettingsMapper _accountSettingsMapper = AccountSettingsMapper();

  @override
  Account mapFrom(AccountEntity entity) {
    return Account(
      id: entity.id,
      accountType: AccountType.values[entity.accountType],
      secret: LockableString.locked(base64String: entity.secret),
      securityLevel: SecurityLevel.values[entity.securityLevel],
      securityAttempts: entity.securityAttempts,
      signedIn: entity.signedIn,
      settings: _accountSettingsMapper.mapFrom(entity.settings),
    );
  }

  @override
  AccountEntity mapTo(Account data) {
    return AccountEntity(
      id: data.id,
      accountType: data.accountType.index,
      secret: data.secret.toString(),
      securityLevel: data.securityLevel.index,
      securityAttempts: data.securityAttempts,
      signedIn: data.signedIn,
      settings: _accountSettingsMapper.mapTo(data.settings),
    );
  }
}

class AccountSettingsMapper
    extends Mapper<AccountSettings, AccountSettingsEntity> {
  @override
  AccountSettings mapFrom(AccountSettingsEntity entity) {
    return AccountSettings(
      themeMode: ThemeMode.values[entity.themeMode],
      locale: Locale(entity.languageCode),
    );
  }

  @override
  AccountSettingsEntity mapTo(AccountSettings data) {
    return AccountSettingsEntity(
      themeMode: data.themeMode.index,
      languageCode: data.locale.languageCode,
    );
  }
}
