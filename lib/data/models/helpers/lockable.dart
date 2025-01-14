import 'dart:convert';
import 'package:simplio_app/data/mixins/aes_encryption_mixin.dart';

abstract class Lockable {
  Lockable lock(String value);
  String unlock(String value);
}

/// Secret is marked with
/// `<secret>.d` for 'decrypted'.
/// `<secret>.e` for encrypted
/// `<secret>.c` for corrupted
const _corruptedSymbol = 'c';
const _encodedSymbol = 'e';
const _decodedSymbol = 'd';

enum SecretState {
  encoded(_encodedSymbol),
  decoded(_decodedSymbol),
  corrupted(_corruptedSymbol);

  final String symbol;
  const SecretState(this.symbol);

  @override
  String toString() {
    return symbol;
  }

  static SecretState fromSymbol(String symbol) {
    switch (symbol) {
      case _encodedSymbol:
        return SecretState.encoded;
      case _decodedSymbol:
        return SecretState.decoded;
      case _corruptedSymbol:
        return SecretState.corrupted;

      default:
        return SecretState.corrupted;
    }
  }
}

class LockableString extends Lockable with AesEncryptionMixin {
  late SecretState _state;
  late String _value;
  late String _iv;

  LockableString.locked({required String base64String}) {
    final bytes = base64.decode(base64String);
    final Map<String, dynamic> map = json.decode(utf8.decode(bytes));

    _value = map['value'] ?? '0';
    _iv = map['iv'] ?? '0';
    _state = SecretState.fromSymbol(
      map['state'] ?? SecretState.corrupted.symbol,
    );
  }

  LockableString.unlocked({required String value}) {
    _iv = generateInitializationVector();
    _value = value;
    _state = SecretState.decoded;
  }

  bool get isLocked => _state == SecretState.encoded;

  @override
  String unlock(String key) {
    if (_state == SecretState.decoded) return _value;
    if (_state == SecretState.encoded) return decrypt(key, _iv, _value);

    throw Exception('Your secret was corrupted');
  }

  @override
  LockableString lock(String key) {
    if (_state == SecretState.encoded) return this;

    _value = encrypt(key, _iv, _value);
    _state = SecretState.encoded;

    return this;
  }

  @override
  String toString() {
    final jsonStr = json.encode(<String, dynamic>{
      "state": _state.toString(),
      "value": _value,
      "iv": _iv,
    });
    return base64.encode(jsonStr.codeUnits);
  }
}

class LockableMnemonic extends Lockable {
  final LockableString value;
  final bool isBackedUp;
  final bool isImported;

  LockableMnemonic({
    required this.value,
    required this.isBackedUp,
    required this.isImported,
  }) : assert(
          isImported ? isBackedUp == isImported : true,
          'If mnemonic is imported, it is considered also backed up',
        );
  LockableMnemonic.locked({
    required String base64Mnemonic,
    required bool isBackedUp,
    required bool isImported,
  }) : this(
          value: LockableString.locked(base64String: base64Mnemonic),
          isBackedUp: isBackedUp,
          isImported: isImported,
        );

  LockableMnemonic.unlocked({
    required String mnemonic,
    bool? isBackedUp,
    bool? isImported,
  }) : this(
          value: LockableString.unlocked(value: mnemonic),
          isBackedUp: isBackedUp ?? false,
          isImported: isImported ?? false,
        );

  LockableMnemonic.imported({
    required String mnemonic,
  }) : this(
          value: LockableString.unlocked(value: mnemonic),
          isBackedUp: true,
          isImported: true,
        );

  @override
  String unlock(String key) {
    return value.unlock(key);
  }

  @override
  LockableMnemonic lock(String key) {
    value.lock(key);
    return this;
  }

  @override
  String toString() {
    return value.toString();
  }
}
