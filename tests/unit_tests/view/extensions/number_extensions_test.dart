import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';

void main() {
  group('BigInt with N-decimals Format Test ', () {
    test(
      'Decimal offset greater than number length',
      () {
        final decimalString =
            BigInt.from(12345).toDecimalString(decimalOffset: 6);
        expect(decimalString, equals('0.012345'));
      },
    );
    test(
      'Decimal offset equals number length',
      () {
        final decimalString =
            BigInt.from(12345).toDecimalString(decimalOffset: 5);
        expect(decimalString, equals('0.12345'));
      },
    );

    test(
      'Decimal offset less than number length',
      () {
        final decimalString =
            BigInt.from(123456).toDecimalString(decimalOffset: 5);
        expect(decimalString, equals('1.23456'));
      },
    );

    test(
      'BigInt with decimal offset 6 rounded on 4 decimal places',
      () {
        final decimalString = BigInt.from(12345)
            .toDecimalString(decimalOffset: 6, decimalPlaces: 4);
        expect(decimalString, equals('0.0123'));
      },
    );

    test(
      'BigInt with decimal offset 9 rounded on 7 decimal places',
      () {
        final decimalString = BigInt.from(12345678)
            .toDecimalString(decimalOffset: 9, decimalPlaces: 7);
        expect(decimalString, equals('0.0123457'));
      },
    );

    test(
      'BigInt with decimal offset 5 rounded on 10 decimal places does not exist'
      ' anymore - it rounds to 2 decimals only if more than 2 trailing zeros',
      () {
        final decimalString = BigInt.from(12345678)
            .toDecimalString(decimalOffset: 5, decimalPlaces: 10);
        expect(decimalString, equals('123.45678'));
      },
    );

    test(
      'BigInt with decimal offset 5 rounded on 10 decimal places does not exist'
      ' anymore - it rounds to 2 decimals only if more than 2 trailing zeros',
      () {
        final decimalString = BigInt.from(10000000)
            .toDecimalString(decimalOffset: 5, decimalPlaces: 10);
        expect(decimalString, equals('100.00'));
      },
    );

    test(
      'BigInt with decimal offset 10 rounded on 10 decimal places to double',
      () {
        final doubleNumber = BigInt.from(123451234512345)
            .toDoubleWithDecimalOffset(decimalOffset: 10);
        expect(doubleNumber, equals(12345.1234512345));
      },
    );

    test(
      'BigInt with decimal offset 10 rounded on 5 decimal places to double',
      () {
        final doubleNumber = BigInt.from(123451234565321)
            .toDoubleWithDecimalOffset(decimalOffset: 10);
        expect(doubleNumber, equals(12345.1234565321));
      },
    );

    test(
      'BigInt with decimal offset 5 rounded on 10 decimal places to double',
      () {
        final doubleNumber = BigInt.from(123451234512345)
            .toDoubleWithDecimalOffset(decimalOffset: 5);
        expect(doubleNumber, equals(1234512345.12345));
      },
    );

    test(
      '122 with 1 decimal',
      () {
        final decimalString =
            BigInt.from(122).toDecimalString(decimalOffset: 1);
        expect(decimalString, equals('12.2'));
      },
    );

    test(
      '1222 with 1 decimal',
      () {
        final decimalString =
            BigInt.from(1222).toDecimalString(decimalOffset: 1);
        expect(decimalString, equals('122.2'));
      },
    );

    test(
      '1234567 with 1 decimal',
      () {
        final decimalString =
            BigInt.from(1234567).toDecimalString(decimalOffset: 1);
        expect(decimalString, equals('123456.7'));
      },
    );

    test(
      '12345678901 with 5 decimals',
      () {
        final decimalString =
            BigInt.from(12345678901).toDecimalString(decimalOffset: 5);
        expect(decimalString, equals('123456.78901'));
      },
    );

    test(
      '12345678901234 with 5 decimals',
      () {
        final decimalString =
            BigInt.from(12345678901234).toDecimalString(decimalOffset: 5);
        expect(decimalString, equals('123456789.01234'));
      },
    );

    test(
      '5000000000000 with 7 decimals will keep only 2 trailing zeros after shifting 7 places to the left',
      () {
        final decimalString =
            BigInt.from(5000000000000).toDecimalString(decimalOffset: 7);
        expect(decimalString, equals('500000.00'));
      },
    );
  });
  group('Currency Format Test', () {
    final bigInt = BigInt.from(123451234512345);
    const decimalPlaces = 10;
    final decimal =
        bigInt.toDoubleWithDecimalOffset(decimalOffset: decimalPlaces);

    test(
      'US Using a Decimal Point to Separate Dollars and Cents',
      () {
        final formattedValue = NumberFormat.currency(
          locale: 'en_US',
          symbol: '\$',
          decimalDigits: 10,
        ).format(decimal);
        expect(formattedValue, equals('\$12,345.1234512345'));
      },
    );

    test(
      'France Using a Comma to Separate Euros and Cents',
      () {
        final formattedValue = NumberFormat.currency(
          locale: 'fr_FR',
          symbol: '€',
          decimalDigits: 10,
        ).format(decimal);
        expect(formattedValue, equals('12 345,1234512345 €'));
      },
    );

    test(
      'Czech Republic Using a Comma to Euros Dollars and Cents',
      () {
        final formattedValue = NumberFormat.currency(
          locale: 'cs_CS',
          symbol: '€',
          decimalDigits: 10,
        ).format(decimal);
        expect(formattedValue, equals('12 345,1234512345 €'));
      },
    );
  });
}
