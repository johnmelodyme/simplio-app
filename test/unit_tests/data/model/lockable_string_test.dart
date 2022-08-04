import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/model/lockable_string.dart';
import 'package:string_validator/string_validator.dart' as string_validator;

const secretValue = 'secret_value';

void main() {
  group('LockableString:', () {
    test(
      'value is base64 encoded.',
      () {
        final str = LockableString.generate();
        expect(string_validator.isBase64(str.toString()), isTrue);
      },
    );

    test(
      'value is a valid json string',
      () {
        final str = LockableString.generate();
        final bytes = base64.decode(str.toString());
        final jsonStr = utf8.decode(bytes);
        expect(string_validator.isJson(jsonStr), isTrue);
      },
    );

    test(
      'value map contains required keys',
      () {
        final str = LockableString.generate();
        final map = _toMap(str);
        final keys = map.keys.toSet().toList();
        final requiredKeys = ['value', 'iv', 'state'];
        expect(keys, allOf(containsAll(requiredKeys)));
      },
    );

    test(
      'with a provided value is decoded by default',
      () {
        final str = LockableString.value(secretValue);
        expect(str.isLocked, isFalse);
      },
    );

    test(
      'with a provided value has an unlocked value',
      () {
        final str = LockableString.value(secretValue);
        expect(str.unlockedValue, isNotNull);
      },
    );

    test(
      "'unlocked' value from a base64 string has same value as original input",
      () {
        final str = LockableString.value(secretValue);
        final strFrom = LockableString.from(base64String: str.toString());
        final unlockedValue = strFrom.unlock('');
        expect(unlockedValue, equals(secretValue));
      },
    );

    test(
      "'locked' value is not the same as the original value",
      () {
        final originalStr = LockableString.value(secretValue).toString();
        final lockedStr = LockableString.from(base64String: originalStr)
          ..lock('123456');

        expect(lockedStr.toString(), isNot(originalStr));
      },
    );

    test(
      "'unlocked' value holds different state than 'locked' value.",
      () {
        const key = '123456';
        final originalStr = LockableString.value(secretValue).toString();
        final unlockedStr = LockableString.from(base64String: originalStr)
          ..lock(key)
          ..unlock(key);

        expect(unlockedStr.toString(), isNot(originalStr));
      },
    );

    test(
      "'unlocked' value holds decoded state.",
      () {
        final str = LockableString.generate();
        final map = _toMap(str);
        final SecretState state = SecretState.fromSymbol(map['state']);
        expect(state, equals(SecretState.decoded));
      },
    );

    test(
      "'locked' value holds encoded state.",
      () {
        final str = LockableString.generate().lock('123456');
        final map = _toMap(str);
        final SecretState state = SecretState.fromSymbol(map['state']);
        expect(state, equals(SecretState.encoded));
      },
    );
  });

  group(
    'Generated LockableString:',
    () {
      test(
        'is decoded by default',
        () {
          final str = LockableString.generate();
          expect(str.isLocked, isFalse);
        },
      );

      test(
        'has an unlocked value',
        () {
          final str = LockableString.generate();
          expect(str.unlockedValue, isNotNull);
        },
      );
    },
  );
}

Map<String, dynamic> _toMap(LockableString str) {
  final bytes = base64.decode(str.toString());
  return json.decode(utf8.decode(bytes));
}
