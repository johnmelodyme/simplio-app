import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/gradient_text.dart';
import 'package:simplio_app/view/widgets/outlined_container.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:sio_glyphs/sio_icons.dart';

class OutlinedSioButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final Widget? icon;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? endBorderColor;

  const OutlinedSioButton({
    super.key,
    this.onPressed,
    this.label,
    this.icon,
    this.labelColor,
    this.backgroundColor,
    this.borderColor,
    this.endBorderColor,
  });

  factory OutlinedSioButton.solid({
    Key? key,
    required VoidCallback? onPressed,
    required String label,
    required Widget? icon,
    required Color? labelColor,
    required Color? backgroundColor,
    required Color? borderColor,
  }) {
    return _OutlinedButton(
      key: key,
      onPressed: onPressed,
      label: label,
      icon: icon,
      labelColor: labelColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor ?? SioColors.secondary6,
    );
  }

  factory OutlinedSioButton.gradient({
    Key? key,
    required String label,
    required VoidCallback onPressed,
  }) {
    return _GradientOutlinedButton(
      key: key,
      label: label,
      onPressed: onPressed,
      startBorderColor: SioColors.highlight1,
      endBorderColor: SioColors.vividBlue,
    );
  }

  factory OutlinedSioButton.earning({
    Key? key,
    VoidCallback? onPressed,
    required EarningType earningType,
    double? apyPercentage,
    BigDecimal? balance,
    double? increment,
  }) {
    return _OutlinedEarningButton(
      key: key,
      onPressed: onPressed,
      earningType: earningType,
      apyPercentage: apyPercentage,
      balance: balance,
      increment: increment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _OutlinedButton(
      key: key,
      onPressed: onPressed,
      label: label,
      icon: icon,
      labelColor: labelColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    );
  }
}

class _OutlinedButton extends OutlinedSioButton {
  const _OutlinedButton({
    Key? key,
    required VoidCallback? onPressed,
    required String? label,
    required Widget? icon,
    required Color? labelColor,
    required Color? backgroundColor,
    required Color? borderColor,
  }) : super(
          key: key,
          onPressed: onPressed,
          label: label,
          icon: icon,
          labelColor: labelColor,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
        );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(Constants.buttonHeight),
        backgroundColor: SioColors.transparent,
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadii.radius30,
          side: BorderSide(
            color: borderColor ?? SioColors.secondary6,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            Gaps.gap10,
          ],
          Text(
            label ?? '',
            style: SioTextStyles.buttonLarge.apply(
              color: labelColor ?? SioColors.secondary6,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientOutlinedButton extends OutlinedSioButton {
  const _GradientOutlinedButton({
    super.key,
    required String label,
    required VoidCallback onPressed,
    required Color startBorderColor,
    required Color endBorderColor,
  }) : super(
          label: label,
          onPressed: onPressed,
          borderColor: startBorderColor,
          endBorderColor: endBorderColor,
        );

  @override
  Widget build(BuildContext context) {
    return OutlinedGradientWrapper(
      startBorderColor: borderColor!,
      endBorderColor: endBorderColor!,
      buttonHeight: Constants.buttonHeight,
      onPressed: onPressed,
      child: Padding(
        padding: Paddings.horizontal20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label ?? '',
              style: SioTextStyles.buttonLarge.copyWith(
                color: SioColors.whiteBlue,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OutlinedEarningButton extends OutlinedSioButton {
  final EarningType earningType;
  final double? apyPercentage;
  final BigDecimal? balance;
  final double? increment;

  const _OutlinedEarningButton({
    super.key,
    final VoidCallback? onPressed,
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
    return OutlinedGradientWrapper(
      buttonHeight: Constants.earningButtonHeight,
      startBorderColor: SioColors.coins,
      endBorderColor: SioColors.earningStart,
      onPressed: onPressed,
      child: Padding(
        padding: Paddings.horizontal20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientText(
              earningType == EarningType.earning
                  ? context.locale.coin_detail_screen_earning_label
                  : context.locale.coin_detail_screen_start_earning_label,
              style: SioTextStyles.bodyPrimary.apply(
                color: SioColors.secondary6,
              ),
              gradient: LinearGradient(
                colors: [
                  SioColors.coins,
                  SioColors.earningStart,
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
                          SioColors.backGradient3Start,
                          SioColors.backGradient3End,
                        ],
                      ),
                    ),
                    child: Text(
                      context.locale
                          .coin_detail_screen_apy_percentage(apyPercentage!),
                      style: SioTextStyles.bodyDetail.apply(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        CurrencyText(
                          value: balance ?? const BigDecimal.zero(),
                          style: SioTextStyles.bodyL
                              .apply(color: SioColors.whiteBlue)
                              .copyWith(height: 1.0),
                        ),
                        Text(
                          context.locale
                              .coin_detail_screen_earning_last_week_increment(
                                  increment!),
                          style: SioTextStyles.bodyL
                              .apply(color: SioColors.mentolGreen)
                              .copyWith(height: 1.0),
                        )
                      ]),
            Gaps.gap20,
            Icon(
              SioIcons.arrow_right,
              size: 10,
              color: SioColors.mentolGreen,
            ),
          ],
        ),
      ),
    );
  }
}

enum EarningType { startEarning, earning }

class OutlinedGradientWrapper extends StatelessWidget {
  const OutlinedGradientWrapper({
    super.key,
    required this.child,
    this.onPressed,
    required this.startBorderColor,
    required this.endBorderColor,
    required this.buttonHeight,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color startBorderColor;
  final Color endBorderColor;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius30,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed?.call(),
          child: SizedBox(
            height: buttonHeight,
            child: OutlinedContainer(
              strokeWidth: 1,
              radius: RadiusSize.radius30,
              gradient: LinearGradient(
                colors: [startBorderColor, endBorderColor],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
