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

    //pad with leading zeros if needed
    if (originalNumber.length <= decimalOffset) {
      int offset = decimalOffset + 1 - originalNumber.length;
      originalNumber = '${'0' * offset}$originalNumber';
    }

    formattedNumber =
        "${originalNumber.substring(0, originalNumber.length - decimalOffset)}."
        "${originalNumber.substring(originalNumber.length - decimalOffset, originalNumber.length)}";

    formattedNumber = trimRight(
        double.parse(formattedNumber).toStringAsFixed(maxDecimalPlaces), '0');

    if (formattedNumber.split('').last == '.') {
      formattedNumber = '${formattedNumber.replaceFirst('.', '')}.00';
    }

    return formattedNumber;
  }
}

String trimLeft(String from, String pattern) {
  if (from.isEmpty || pattern.isEmpty || pattern.length > from.length) {
    return from;
  }

  while (from.startsWith(pattern)) {
    from = from.substring(pattern.length);
  }
  return from;
}

String trimRight(String from, String pattern) {
  if (from.isEmpty || pattern.isEmpty || pattern.length > from.length) {
    return from;
  }

  while (from.endsWith(pattern)) {
    from = from.substring(0, from.length - pattern.length);
  }
  return from;
}

String trim(String from, String pattern) {
  return trimLeft(trimRight(from, pattern), pattern);
}

BigInt doubleStringToBigInt(String number, int decimalPlaces) {
  List<String> split = number.split('.');
  if (split.length == 1) {
    return BigInt.parse(
        split.first.padRight(split.first.length + decimalPlaces, '0'));
  }

  if (split.length > 1) {
    split.last = trimRight(split.last, '0').padRight(decimalPlaces, '0');
    return BigInt.parse(split.join());
  }

  throw Exception('Unknown exception in toBigIntFromDoubleString function');
}
