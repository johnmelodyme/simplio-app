import 'package:flutter/material.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/helpers/lockable_string.dart';

class AccountRepository {
  final AccountDb _accountDb;

  const AccountRepository._(this._accountDb);

  const AccountRepository.builder({
    required AccountDb accountDb,
  }) : this._(accountDb);

  Future<Account> save(Account account) async {
    return _accountDb.save(account);
  }

  Account? get(String id) {
    return _accountDb.get(id);
  }

  Future<Account> updateSecret(
    Account acc, {
    required String key,
    String? prevKey,
  }) async {
    final level = acc.securityLevel.index < SecurityLevel.pin.index
        ? SecurityLevel.pin
        : acc.securityLevel;

    if (prevKey != null) {
      try {
        final unlockedSecret = acc.secret.unlock(prevKey);
        final updatedSecret = LockableString.unlocked(value: unlockedSecret);

        updatedSecret.lock(key);
        return save(acc.copyWith(
          secret: updatedSecret,
          securityLevel: level,
        ));
      } catch (e) {
        throw Exception('Updating Secret with old key has failed');
      }
    }

    try {
      acc.secret.lock(key);
      return save(acc.copyWith(
        securityLevel: level,
      ));
    } catch (e) {
      throw Exception('Updating Secret has failed');
    }
  }

  Future<Account> updateLanguage(
    Account acc, {
    required String languageCode,
  }) {
    return save(acc.copyWith(
      settings: acc.settings.copyWith(
        locale: Locale(languageCode),
      ),
    ));
  }

  Future<Account> updateTheme(
    Account acc, {
    required ThemeMode themeMode,
  }) {
    return save(acc.copyWith(
      settings: acc.settings.copyWith(
        themeMode: themeMode,
      ),
    ));
  }

  PinVerifyResponse verifyPin(Account acc, String pin) {
    String? secret;

    try {
      secret = acc.secret.unlock(pin);
    } catch (e) {
      secret = null;
    }

    return PinVerifyResponse(
      secret: secret,
      account: acc.copyWith(
          securityAttempts: secret != null
              ? securityAttemptsLimit
              : acc.securityAttempts - 1),
    );
  }
}

class PinVerifyResponse {
  final String? secret;
  final Account account;

  const PinVerifyResponse({
    required this.secret,
    required this.account,
  });
}

abstract class AccountDb {
  Account? get(String id);
  Future<Account> save(Account account);
  Account? getLast();
}
