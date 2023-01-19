import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/providers/interfaces/account_db.dart';

class AccountRepository {
  final AccountDb _accountDb;

  const AccountRepository._(this._accountDb);

  const AccountRepository.builder({
    required AccountDb accountDb,
  }) : this._(accountDb);

  Future<Account> save(Account account) async {
    return _accountDb.save(account);
  }

  Future<Account?> get(String id) async {
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
            : max(acc.securityAttempts - 1, 0),
      ),
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
