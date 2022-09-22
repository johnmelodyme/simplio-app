import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/model/helpers/lockable_string.dart';
import 'package:string_validator/string_validator.dart' as string_validator;

const secretValue = 'secret_value';

void main() {
  group('LockableString:', () {
    final LockableString str = LockableString.unlocked(value: secretValue);

    test(
      'value is base64 encoded.',
      () {
        expect(string_validator.isBase64(str.toString()), isTrue);
      },
    );

    test(
      'value is a valid json string.',
      () {
        final bytes = base64.decode(str.toString());
        final jsonStr = utf8.decode(bytes);
        expect(string_validator.isJson(jsonStr), isTrue);
      },
    );

    test(
      'value map contains required keys',
      () {
        final map = _toMap(str);
        final keys = map.keys.toSet().toList();
        final requiredKeys = ['value', 'iv', 'state'];
        expect(keys, allOf(containsAll(requiredKeys)));
      },
    );

    test(
      'with a provided value is decoded by default.',
      () {
        final str = LockableString.unlocked(value: secretValue);
        expect(str.isLocked, isFalse);
      },
    );

    test(
      "'unlocked' value from a base64 string has same value as original input.",
      () {
        final strFrom = LockableString.locked(base64String: str.toString());
        final unlockedValue = strFrom.unlock('');
        expect(unlockedValue, equals(secretValue));
      },
    );

    test(
      "cloned 'decoded' string holds the same value as the original string.",
      () {
        final originalStr =
            LockableString.unlocked(value: secretValue).toString();
        final clonedStr = LockableString.locked(base64String: originalStr);

        expect(clonedStr.toString(), equals(originalStr));
      },
    );

    test(
      "cloned 'encoded' string holds the same value as the original string.",
      () {
        const key = '123456';
        final originalStr =
            LockableString.unlocked(value: secretValue).lock(key).toString();
        final clonedStr = LockableString.locked(base64String: originalStr);

        expect(clonedStr.toString(), equals(originalStr));
      },
    );

    test(
      "'locked' value is not the same as the original value.",
      () {
        final originalStr =
            LockableString.unlocked(value: secretValue).toString();
        final lockedStr = LockableString.locked(
          base64String: originalStr,
        ).lock('123456');

        expect(lockedStr.toString(), isNot(originalStr));
      },
    );

    test(
      "'unlocked' value holds different state than 'locked' value.",
      () {
        const key = '123456';
        final originalStr =
            LockableString.unlocked(value: secretValue).toString();
        final unlockedStr = LockableString.locked(base64String: originalStr)
            .lock(key)
            .unlock(key);

        expect(unlockedStr.toString(), isNot(originalStr));
      },
    );

    test(
      "cannot perform double locking.",
      () {
        const key = '123456';
        final unlockedStr = LockableString.unlocked(value: secretValue)
            .lock(key)
            .lock(key)
            .unlock(key);

        expect(unlockedStr, equals(secretValue));
      },
    );

    test(
      "'unlocked' value holds decoded state.",
      () {
        // final str = LockableString.generate();
        final map = _toMap(str);
        final SecretState state = SecretState.fromSymbol(map['state']);
        expect(state, equals(SecretState.decoded));
      },
    );

    test(
      "'locked' value holds encoded state.",
      () {
        final str = LockableString.unlocked(value: secretValue).lock('123456');
        final map = _toMap(str);
        final SecretState state = SecretState.fromSymbol(map['state']);
        expect(state, equals(SecretState.encoded));
      },
    );
  });
}

Map<String, dynamic> _toMap(LockableString str) {
  final bytes = base64.decode(str.toString());
  return json.decode(utf8.decode(bytes));
}
