import 'package:intl/intl.dart';

enum CurrencySide { left, right }

extension DoubleParseExtension on double {
  String getThousandSeparatedValue() {
    NumberFormat numberFormat = NumberFormat("#,##0.00");
    return numberFormat.format(this);
  }

  String getThousandValueWithCurrency({
    final String currencySymbol = '\$',
    final CurrencySide currencySide = CurrencySide.left,
  }) {
    String formattedValue = getThousandSeparatedValue();

    if (currencySide == CurrencySide.left) {
      return '$currencySymbol$formattedValue';
    } else {
      return '$formattedValue$currencySymbol';
    }
  }
}

extension BigIntParseExtension on BigInt {
  String getFormattedBalance(final int decimalPlaces) {
    return toDecimalString(decimalOffset: decimalPlaces);
  }

  String getFormattedPrice({
    final int decimalPlaces = 2,
    final String? locale,
    final String? symbol = '\$',
  }) {
    return format(
      digits: decimalPlaces,
      locale: locale,
      symbol: symbol,
    );
  }

  String format({
    required final int digits,
    final String? locale,
    final String? symbol,
  }) {
    double doubleNumber = toDoubleWithDecimalOffset(decimalOffset: digits);

    final formattedValue = NumberFormat.currency(
      decimalDigits: digits,
      locale: locale,
      symbol: symbol,
    ).format(doubleNumber);

    return formattedValue;
  }

  double toDoubleWithDecimalOffset({
    required final int decimalOffset,
  }) {
    final decimalString = toDecimalString(
      decimalOffset: decimalOffset,
      decimalPlaces: decimalOffset,
    );

    return double.parse(decimalString);
  }

  String toDecimalString({
    required final int decimalOffset,
    final int? decimalPlaces,
  }) {
    final maxDecimalPlaces = decimalPlaces ?? decimalOffset;

    String originalNumber = toString();
    String formattedNumber;

    //pad with leading zerros if need
    if (originalNumber.length <= decimalOffset) {
      int offset = decimalOffset + 1 - originalNumber.length;
      originalNumber = '${'0' * offset}$originalNumber';
    }

    formattedNumber =
        "${originalNumber.substring(0, originalNumber.length - decimalOffset)}."
        "${originalNumber.substring(originalNumber.length - decimalOffset, originalNumber.length)}";

    return double.parse(formattedNumber).toStringAsFixed(maxDecimalPlaces);
  }
}
