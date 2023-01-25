import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

class CurrencyText extends StatelessWidget {
  final String locale;
  final String? currency;
  final BigDecimal value;
  final TextStyle? style;

  const CurrencyText({
    super.key,
    required this.value,
    this.locale = 'en_US',
    this.currency,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.simpleCurrency(name: currency);
    final symbol = currency != null ? format.currencySymbol : '';
    const defaultValue = '0';
    return Text(
      '$symbol${value.isZero ? defaultValue : value.format(locale: locale)}',
      style: style ??
          SioTextStyles.bodyS.copyWith(
            color: SioColors.whiteBlue,
          ),
    );
  }
}
