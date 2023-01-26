import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

class TotalBalanceOverview extends StatelessWidget {
  final BigDecimal balance;
  final String currency;

  const TotalBalanceOverview({
    super.key,
    this.balance = const BigDecimal.zero(),
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(RadiusSize.radius20)),
            color: SioColors.backGradient4Start,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SioColors.backGradient4Start,
                SioColors.softBlack,
              ],
            ),
          ),
          child: Padding(
            padding: Paddings.vertical16,
            child: Column(children: [
              Text(
                context.locale.inventory_screen_inventory_balance,
                style: SioTextStyles.bodyPrimary
                    .copyWith(height: 1.0)
                    .apply(color: SioColors.secondary6),
              ),
              Gaps.gap5,
              CurrencyText(
                balance,
                currency: currency,
                precision: 2,
                style: SioTextStyles.h1.apply(
                  color: SioColors.mentolGreen,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
