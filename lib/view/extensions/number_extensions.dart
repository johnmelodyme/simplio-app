import 'package:intl/intl.dart';

enum CurrencySide { left, right }

String getCurrencySymbol(String currency) {
  switch (currency) {
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';

    default:
      return throw Exception('No currency symbol defined');
  }
}

extension DoubleParseExtension on double {
  String getThousandSeparatedValue() {
    NumberFormat numberFormat = NumberFormat("#,##0.00");
    return numberFormat.format(this);
  }

  String getThousandValueWithCurrency({
    required final String currency,
    required final String locale,
  }) {
    final formattedValue = NumberFormat.currency(
      decimalDigits: 2,
      locale: locale,
      symbol: getCurrencySymbol(currency),
    ).format(this);

    return formattedValue;
  }
}

extension BigIntParseExtension on BigInt {
  String getFormattedBalance(final int decimalPlaces) {
    return toDecimalString(decimalOffset: decimalPlaces);
  }

  String getFormattedPrice({
    final int decimalPlaces = 2,
    required final String locale,
    required final String currency,
  }) {
    return format(
      digits: decimalPlaces,
      locale: locale,
      symbol: getCurrencySymbol(currency),
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
