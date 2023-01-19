import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/mixins/aes_encryption_mixin.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:string_validator/string_validator.dart' as string_validator;

void main() {
  group(
    'Secret:',
    () {
      test(
        'is encoded base64 string.',
        () {
          final secretBase64 = Account.generateSecret();
          expect(string_validator.isBase64(secretBase64), isTrue);
        },
      );

      test(
        "generated secret has length of $keyByteSize bytes.",
        () {
          final secretBase64 = Account.generateSecret();
          final secretBytes = base64.decode(secretBase64);
          expect(secretBytes.length, equals(keyByteSize));
        },
      );

      test(
        'is a unique value in 100 generated values.',
        () {
          const length = 100;
          final ivs = List.generate(
            length,
            (index) => Account.generateSecret(),
          ).toSet();
          expect(ivs.length, equals(length));
        },
      );
    },
  );

  group(
    'Account:',
    () {
      test(
        'two registered accounts do not have same secret.',
        () {
          final a1 = Account.registered(
            id: 'Account 1',
            signedIn: DateTime.now(),
          );
          final a2 = Account.registered(
            id: 'Account 2',
            signedIn: DateTime.now(),
          );

          expect(a1.secret.toString(), isNot(equals(a2.secret.toString())));
        },
      );

      test(
        "registered account is 'registered' type.",
        () {
          final a = Account.registered(
            id: 'Account',
            signedIn: DateTime.now(),
          );

          expect(a.accountType, equals(AccountType.registered));
        },
      );

      test(
        "anonymous account is 'anonymous' type.",
        () {
          final a = Account.anonymous();

          expect(a.accountType, equals(AccountType.anonymous));
        },
      );
    },
  );
}
