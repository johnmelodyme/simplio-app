import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/lockable_string.dart';
import 'package:simplio_app/data/providers/account_db_provider.dart';

class AccountRepository {
  final AccountDbProvider _db;

  const AccountRepository._(this._db);

  const AccountRepository.builder({
    required AccountDbProvider db,
  }) : this._(db);

  Future<AccountRepository> init() async {
    await _db.init();

    return this;
  }

  Future<Account> save(Account account) async {
    return _db.save(account);
  }

  Account? get(String id) {
    return _db.get(id);
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
        final updatedSecret = LockableString.value(unlockedSecret);

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

  PinVerifyResponse verifyPin(Account acc, String pin) {
    bool isValid;

    try {
      acc.secret.unlock(pin);
      isValid = true;
    } catch (e) {
      isValid = false;
    }

    return PinVerifyResponse(
      isValid: isValid,
      account: acc.copyWith(
          securityAttempts:
              isValid ? securityAttemptsLimit : acc.securityAttempts - 1),
    );
  }
}

class PinVerifyResponse {
  final bool isValid;
  final Account account;

  const PinVerifyResponse({
    required this.isValid,
    required this.account,
  });
}
