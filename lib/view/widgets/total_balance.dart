import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class TotalBalance extends StatefulWidget {
  const TotalBalance({
    super.key,
    required this.balance,
    this.defaultPeriodType = PeriodType.week,
  });

  final double balance;
  final PeriodType defaultPeriodType;

  @override
  State<TotalBalance> createState() => _TotalBalanceState();
}

class _TotalBalanceState extends State<TotalBalance> {
  late PeriodType _periodType;

  @override
  void initState() {
    _periodType = widget.defaultPeriodType;
    super.initState();
  }

  String _getPeriodTimeValue() {
    int dividerValue;
    switch (_periodType) {
      case PeriodType.week:
        dividerValue = 52;
        break;
      case PeriodType.month:
        dividerValue = 12;
        break;
      case PeriodType.months3:
        dividerValue = 4;
        break;
      case PeriodType.months6:
        dividerValue = 2;
        break;
      case PeriodType.year:
      default:
        dividerValue = 1;
        break;
    }

    return (widget.balance / dividerValue).getThousandValueWithCurrency(
      currency: 'USD', //TODO.. replace by real currency
      locale: Intl.getCurrentLocale(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: SliverToBoxAdapter(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(RadiusSize.radius20)),
                color: SioColors.backGradient4Start,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SioColors.backGradient4Start,
                      SioColors.softBlack
                    ])),
            child: Padding(
              padding: Paddings.vertical16,
              child: Column(children: [
                Text(
                  context.locale.inventory_screen_inventory_balance,
                  style: SioTextStyles.bodyPrimary.copyWith(height: 1.0).apply(
                        color: SioColors.secondary6,
                      ),
                ),
                Gaps.gap5,
                Text(
                  widget.balance.getThousandValueWithCurrency(
                    currency: 'USD', //TODO.. replace by real currency
                    locale: Intl.getCurrentLocale(),
                  ),
                  style: SioTextStyles.h1.apply(color: SioColors.mentolGreen),
                ),
                Gaps.gap5,
                SizedBox(
                  width: 160.0,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<PeriodType>(
                        isDense: true,
                        isExpanded: true,
                        focusColor: SioColors.whiteBlue,
                        dropdownColor: SioColors.secondary1,
                        value: _periodType,
                        elevation: 0,
                        iconSize: 20,
                        style: SioTextStyles.bodyPrimary.apply(
                          color: SioColors.mentolGreen,
                        ),
                        iconEnabledColor: SioColors.mentolGreen,
                        icon: const SizedBox
                            .shrink(), // const Icon(Icons.expand_more),
                        selectedItemBuilder: (context) {
                          return PeriodType.values
                              .map<Widget>((PeriodType periodType) {
                            return SizedBox(
                              width: 160,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_getPeriodTimeValue(),
                                      style: SioTextStyles.bodyPrimary.apply(
                                        color: SioColors.whiteBlue,
                                      )),
                                  Icon(Icons.expand_more,
                                      color: SioColors.whiteBlue)
                                ],
                              ),
                            );
                          }).toList();
                        },
                        items: PeriodType.values
                            .map<DropdownMenuItem<PeriodType>>(
                                (PeriodType periodType) {
                          String periodName = context.locale
                              .common_period_section(periodType.name);
                          return DropdownMenuItem<PeriodType>(
                            alignment: Alignment.center,
                            value: periodType,
                            child: Center(
                              child: Text(
                                periodName,
                                style: SioTextStyles.bodyPrimary.apply(
                                  color: periodType == _periodType
                                      ? SioColors.mentolGreen
                                      : SioColors.whiteBlue,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        hint: SizedBox(
                          width: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_getPeriodTimeValue(),
                                  style: SioTextStyles.bodyPrimary.apply(
                                    color: SioColors.mentolGreen,
                                  )),
                              Icon(Icons.expand_more,
                                  color: SioColors.mentolGreen)
                            ],
                          ),
                        ),
                        onChanged: (PeriodType? periodType) {
                          setState(() {
                            _periodType = periodType!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            )),
      ),
    );
  }
}

enum PeriodType {
  week,
  month,
  months3,
  months6,
  year,
}
