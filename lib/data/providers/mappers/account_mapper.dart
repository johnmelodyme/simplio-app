import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/providers/entities/account_entity.dart';

extension AccountWalletEntityMapper on AccountEntity {
  Account toModel() {
    return Account(
      id: id,
      accountType: AccountType.values[accountType],
      secret: LockableString.locked(base64String: secret),
      securityLevel: SecurityLevel.values[securityLevel],
      securityAttempts: securityAttempts,
      signedIn: signedIn,
      settings: settings.toModel(),
    );
  }
}

extension AccountSettingsEntityMapper on AccountSettingsEntity {
  AccountSettings toModel() {
    return AccountSettings(
      themeMode: ThemeMode.values[themeMode],
      locale: Locale(languageCode),
    );
  }
}

extension AccountMapper on Account {
  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      accountType: accountType.index,
      secret: secret.toString(),
      securityLevel: securityLevel.index,
      securityAttempts: securityAttempts,
      signedIn: signedIn,
      settings: settings.toEntity(),
    );
  }
}

extension AccountSettingsMapper on AccountSettings {
  AccountSettingsEntity toEntity() {
    return AccountSettingsEntity(
      themeMode: themeMode.index,
      languageCode: locale.languageCode,
    );
  }
}
