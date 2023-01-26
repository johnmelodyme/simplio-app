import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

class CurrencyText extends StatelessWidget {
  final String locale;
  final int? precision;
  final String? currency;
  final BigDecimal value;
  final TextStyle? style;

  const CurrencyText(
    this.value, {
    super.key,
    this.locale = 'en_US',
    this.precision,
    this.currency,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.simpleCurrency(name: currency);
    final symbol = currency != null ? format.currencySymbol : '';
    const defaultValue = '0';

    String v = value.format(locale: locale);

    if (precision != null) {
      final start = v.indexOf('.') + 1;
      final end = min(start + precision!, v.length);
      v = value.isDecimal ? v.substring(0, end) : v;
    }

    return Text(
      '$symbol${value.isZero ? defaultValue : v}',
      style: style ??
          SioTextStyles.bodyS.copyWith(
            color: SioColors.whiteBlue,
          ),
    );
  }
}
