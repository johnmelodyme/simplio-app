import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/mixins/aes_encryption_mixin.dart';
import 'package:string_validator/string_validator.dart' as string_validator;

const _secretValue = 'secret_value';
const _key = '123456';

class AesEncryptionTester with AesEncryptionMixin {}

void main() {
  AesEncryptionTester tester = AesEncryptionTester();

  group(
    'Aes key length:',
    () {
      test(
        "key from a provided value has length of $keyByteSize bytes.",
        () {
          final key = tester.makeKey('123456');
          expect(key.length, equals(keyByteSize));
        },
      );

      test(
        "key from a provided long value has length of $keyByteSize bytes.",
        () {
          const s = '1234567891011121314151617181920212223242526';
          final key = tester.makeKey(s);
          expect(key.length, equals(keyByteSize));
        },
      );
    },
  );

  group(
    'IV:',
    () {
      late String ivBase64;
      late Uint8List ivBytes;

      setUp(() {
        ivBase64 = tester.generateInitializationVector();
        ivBytes = base64.decode(ivBase64);
      });

      test(
        'is a unique value in 100 generated values.',
        () {
          const length = 100;
          final ivs = List.generate(
            length,
            (index) => tester.generateInitializationVector(),
          ).toSet();
          expect(ivs.length, equals(length));
        },
      );

      test(
        'is base64 encoded string.',
        () {
          expect(string_validator.isBase64(ivBase64), isTrue);
        },
      );

      test(
        "has length of $ivByteSize bytes.",
        () {
          expect(ivBytes.length, equals(ivByteSize));
        },
      );
    },
  );

  group(
    'Aes encryption:',
    () {
      late String ivBase64;

      setUp(() {
        ivBase64 = tester.generateInitializationVector();
      });

      test(
        'encrypted value is base64 encoded string.',
        () {
          final encryptedStr = tester.encrypt(_key, ivBase64, _secretValue);
          expect(string_validator.isBase64(encryptedStr), isTrue);
        },
      );
    },
  );

  group(
    'Aes decryption:',
    () {
      late String ivBase64;
      setUp(() {
        ivBase64 = tester.generateInitializationVector();
      });

      test(
        'decrypted value is same as the original.',
        () {
          final encryptedStr = tester.encrypt(_key, ivBase64, _secretValue);
          final decryptedStr = tester.decrypt(_key, ivBase64, encryptedStr);
          expect(decryptedStr, equals(_secretValue));
        },
      );
    },
  );
}
