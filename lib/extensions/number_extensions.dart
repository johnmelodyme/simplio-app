import 'package:intl/intl.dart';

extension DoubleParseExtension on double {
  String getThousandSeparatedValue() {
    NumberFormat numberFormat = NumberFormat("#,##0.00");
    return numberFormat.format(this);
  }

  String getThousandValueWithCurrency({
    String currencySymbol = '\$',
    CurrencySide currencySide = CurrencySide.left,
  }) {
    String formattedValue = getThousandSeparatedValue();

    if (currencySide == CurrencySide.left) {
      return '$currencySymbol$formattedValue';
    } else {
      return '$formattedValue$currencySymbol';
    }
  }
}

enum CurrencySide { left, right }
