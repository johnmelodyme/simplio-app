import 'package:flutter_test/flutter_test.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';

void main() {
  group(
    'FeeData:',
    () {
      final List<BigInt> feeValues = [
        BigInt.from(200),
        BigInt.from(4000),
        BigInt.from(10),
      ];
      final feeData = FeeData(
        gasLimit: BigInt.from(21000),
        unit: 'SATOSHI',
        values: feeValues,
      );

      test(
        'length is equal to input value.',
        () {
          expect(feeData.length, equals(feeValues.length));
        },
      );

      test(
        "'lowFee' value is present if it was provided.",
        () {
          final fee = feeData.lowFee;
          if (feeData.length > 0) {
            expect(fee, isNotNull);
          } else {
            expect(fee, isNull);
          }
        },
      );

      test(
        "'regularFee' value is present if it was provided.",
        () {
          final fee = feeData.regularFee;
          if (feeData.length > 1) {
            expect(fee, isNotNull);
          } else {
            expect(fee, isNull);
          }
        },
      );

      test(
        "'highFee' value is present if it was not provided.",
        () {
          final fee = feeData.highFee;
          if (feeData.length > 2) {
            expect(fee, isNotNull);
          } else {
            expect(fee, isNull);
          }
        },
      );

      test(
        "'highFee' is null when is not present.",
        () {
          final feeData = FeeData(
            gasLimit: BigInt.from(21000),
            unit: 'SATOSHI',
            values: [
              BigInt.from(200),
              BigInt.from(4000),
            ],
          );

          expect(feeData.highFee, isNull);
        },
      );

      test(
        'values are ordered from the lowest to the highest.',
        () {
          bool res = false;

          feeData.values.fold<BigInt>(BigInt.zero, (prev, curr) {
            res = prev.compareTo(curr).isNegative;
            return curr;
          });

          expect(res, isTrue);
        },
      );
    },
  );
}
