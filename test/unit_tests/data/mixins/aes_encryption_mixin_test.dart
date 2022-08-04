import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/mixins/aes_encryption_mixin.dart';
import 'package:string_validator/string_validator.dart' as string_validator;

const keyByteSize = 32;
const ivByteSize = 16;
const secretValue = 'secret_value';
const key = '123456';

class AesEncryptionTester with AesEncryption {}

void main() {
  AesEncryptionTester tester = AesEncryptionTester();

  group(
    'Aes key length:',
    () {
      test(
        "key from a provided value has length of $keyByteSize bytes",
        () {
          final key = tester.makeKey('123456');
          expect(key.length, equals(keyByteSize));
        },
      );

      test(
        "key from a provided long value has length of $keyByteSize bytes",
        () {
          const s = '1234567891011121314151617181920212223242526';
          final key = tester.makeKey(s);
          expect(key.length, equals(keyByteSize));
        },
      );

      test(
        "generated Key base64 Key has length of $keyByteSize bytes",
        () {
          final keyBase64 = tester.generateKey();
          final keyBytes = base64.decode(keyBase64);
          expect(keyBytes.length, equals(keyByteSize));
        },
      );
    },
  );

  group(
    'IV:',
    () {
      late String ivBase64;
      late Uint8List ivBytes;

      setUp(
        () {
          ivBase64 = tester.generateInitializationVector();
          ivBytes = base64.decode(ivBase64);
        },
      );

      test(
        'is base64 encoded string',
        () {
          expect(string_validator.isBase64(ivBase64), isTrue);
        },
      );

      test(
        "has length of $ivByteSize bytes",
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
      setUp(
        () {
          ivBase64 = tester.generateInitializationVector();
        },
      );

      test(
        'encrypted value is base64 encoded string',
        () {
          final encryptedStr = tester.encrypt(key, ivBase64, secretValue);
          expect(string_validator.isBase64(encryptedStr), isTrue);
        },
      );
    },
  );

  group(
    'Aes decryption:',
    () {
      late String ivBase64;
      setUp(
        () {
          ivBase64 = tester.generateInitializationVector();
        },
      );

      test(
        'decrypted value is same as the original',
        () {
          final encryptedStr = tester.encrypt(key, ivBase64, secretValue);
          final decryptedStr = tester.decrypt(key, ivBase64, encryptedStr);
          expect(decryptedStr, equals(secretValue));
        },
      );
    },
  );
}
