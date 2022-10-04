import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/gradient_text.dart';
import 'package:simplio_app/view/widgets/outlined_container.dart';

class EarningElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final EarningType earningType;

  final double? apyPercentage;
  final BigInt? balance;
  final double? increment;

  const EarningElevatedButton({
    super.key,
    this.onPressed,
    required this.earningType,
    this.apyPercentage,
    this.balance,
    this.increment,
  }) : assert(
          apyPercentage != null || (balance != null && increment != null),
          'Either apyPercentage != null or balance with increment shouldn\'t be null !',
        );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius30,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            height: Constants.earningButtonHeight,
            child: OutlinedContainer(
              strokeWidth: 1,
              radius: RadiusSize.radius30,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.onError,
                ],
              ),
              child: Padding(
                padding: Paddings.horizontal20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientText(
                      earningType == EarningType.earning
                          ? context.locale.coin_detail_screen_earning_label
                          : context
                              .locale.coin_detail_screen_start_earning_label,
                      style: SioTextStyles.bodyPrimary.apply(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.onError,
                        ],
                      ),
                    ),
                    const Spacer(),
                    earningType == EarningType.startEarning
                        ? Container(
                            height: 16,
                            padding: Paddings.horizontal4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadii.radius6,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                  Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                ],
                              ),
                            ),
                            child: Text(
                              context.locale.coin_detail_screen_apy_percentage(
                                  apyPercentage!),
                              style: SioTextStyles.bodyDetail.apply(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                Text(
                                  balance!.getFormattedPrice(
                                    decimalPlaces: 2,
                                    locale: Intl.getCurrentLocale(),
                                    currency:
                                        'USD', //TODO.. replace by real currency
                                  ),
                                  style: SioTextStyles.bodyL
                                      .apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      )
                                      .copyWith(height: 1.0),
                                ),
                                Text(
                                  context.locale
                                      .coin_detail_screen_earning_last_week_increment(
                                          increment!),
                                  style: SioTextStyles.bodyL
                                      .apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                      )
                                      .copyWith(height: 1.0),
                                )
                              ]),
                    Gaps.gap20,
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum EarningType { startEarning, earning }
