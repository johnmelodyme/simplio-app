import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_gradient_label.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/swipe_up_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetBuySummaryScreen extends StatelessWidget {
  const AssetBuySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
          listenWhen: (prev, curr) => curr.response is AssetBuyFormPending,
          listener: (context, state) {
            GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetBuyPaymentGateway,
              params: {
                'assetId': state.assetId.toString(),
                'networkId': state.networkId.toString(),
              },
            );
          },
        ),
        BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
          listenWhen: (prev, curr) {
            final response = curr.response;
            return response is AssetBuyFormPriceRefreshSuccess &&
                response.confirmationNeeded;
          },
          listener: (context, state) {
            GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetBuyConfirmation,
              params: {
                'assetId': state.assetId.toString(),
                'networkId': state.networkId.toString(),
              },
            );
          },
        ),
        BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
          listenWhen: (prev, curr) {
            final response = curr.response;
            return response is AssetBuyFormPriceRefreshSuccess &&
                !response.confirmationNeeded;
          },
          listener: (context, state) {
            GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetBuySuccess,
              params: {
                'assetId': state.assetId.toString(),
                'networkId': state.networkId.toString(),
              },
            );
          },
        ),
      ],
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.center,
                colors: [
                  SioColors.backGradient4Start,
                  SioColors.softBlack,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const _AppBar(),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Padding(
                        padding: Paddings.horizontal20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _AmountToBuy(),
                            Gaps.gap20,
                            const _EstimateBuyPrice(),
                            Gaps.gap20,
                            const _PaymentMethod(),
                            Gaps.gap20,
                            const _Fee(),
                            Gaps.gap20,
                            const _InTotalToBuy(),
                          ],
                        ),
                      ),
                      const _SwipeButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
            buildWhen: (prev, curr) =>
                curr.response is AssetBuyFormPriceRefreshPending,
            builder: (context, state) =>
                state.response is AssetBuyFormPriceRefreshPending
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [ListLoading()],
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _AmountToBuy extends StatelessWidget {
  const _AmountToBuy();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
      buildWhen: (prev, curr) =>
          prev.assetId != curr.assetId || prev.amount != curr.amount,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_buy_summary_screen_what_you_buy,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          Row(
            children: [
              Text(
                '${state.fee} ${Assets.getAssetDetail(state.assetId).ticker}',
                style: SioTextStyles.bodyPrimary.copyWith(
                  color: SioColors.whiteBlue,
                ),
              ),
              Expanded(
                child: Text(
                  double.parse(state.fee.isEmpty ? '0' : state.fee)
                      .getThousandValueWithCurrency(
                    currency: 'USD', //TODO.. replace by real currency
                    locale: Intl.getCurrentLocale(),
                  ),
                  textAlign: TextAlign.right,
                  style: SioTextStyles.bodyPrimary.copyWith(
                    color: SioColors.secondary6,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Fee extends StatelessWidget {
  const _Fee();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
      buildWhen: (prev, curr) =>
          prev.assetId != curr.assetId || prev.amount != curr.amount,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_buy_summary_screen_fee,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          Row(
            children: [
              Text(
                '${state.amount} ${Assets.getAssetDetail(state.assetId).ticker}',
                style: SioTextStyles.bodyPrimary
                    .copyWith(color: SioColors.whiteBlue),
              ),
              Expanded(
                child: Text(
                  double.parse(
                          state.amountFiat.isEmpty ? '0' : state.amountFiat)
                      .getThousandValueWithCurrency(
                    currency: 'USD', //TODO.. replace by real currency
                    locale: Intl.getCurrentLocale(),
                  ),
                  textAlign: TextAlign.right,
                  style: SioTextStyles.bodyPrimary.copyWith(
                    color: SioColors.secondary6,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _EstimateBuyPrice extends StatelessWidget {
  const _EstimateBuyPrice();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
      buildWhen: (prev, curr) => prev.price != curr.price,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_buy_summary_screen_estimate_buy_price,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          Row(
            children: [
              Text(
                double.parse(state.price).getThousandValueWithCurrency(
                  currency: 'USD', //TODO.. replace by real currency
                  locale: Intl.getCurrentLocale(),
                ),
                style: SioTextStyles.bodyPrimary
                    .copyWith(color: SioColors.whiteBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethod extends StatelessWidget {
  const _PaymentMethod();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
      buildWhen: (prev, curr) => prev.price != curr.price,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_buy_summary_screen_payment_method,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          Row(
            children: [
              Icon(
                getPaymentMethodIcon(context),
                size: 20,
                color: SioColors.whiteBlue,
              ),
              Gaps.gap5,
              Text(
                getPaymentMethodLabel(context),
                style: SioTextStyles.bodyPrimary
                    .copyWith(color: SioColors.whiteBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData getPaymentMethodIcon(BuildContext context) {
    switch (context.read<AssetBuyFormCubit>().state.paymentMethod) {
      case PaymentMethod.debitCard:
        return SioIcons.credit_card;
      case PaymentMethod.payPal:
        return Icons.paypal;
      case PaymentMethod.applePay:
        return Icons.apple;
      case PaymentMethod.googlePay:
        return Icons.payments;
    }
  }

  String getPaymentMethodLabel(BuildContext context) {
    switch (context.read<AssetBuyFormCubit>().state.paymentMethod) {
      case PaymentMethod.debitCard:
        return context.locale.asset_buy_summary_screen_debit_card;
      case PaymentMethod.payPal:
        return context.locale.asset_buy_summary_screen_paypal;
      case PaymentMethod.applePay:
        return context.locale.asset_buy_summary_screen_apple_pay;
      case PaymentMethod.googlePay:
        return context.locale.asset_buy_summary_screen_google_pay;
    }
  }
}

class _InTotalToBuy extends StatelessWidget {
  const _InTotalToBuy();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_buy_summary_screen_in_total_to_buy,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          AssetFormGradientLabel(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${state.totalAmountToBuy} ${Assets.getAssetDetail(state.assetId).ticker}',
                        style: SioTextStyles.h4.apply(
                          color: SioColors.mentolGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    double.parse(state.totalAmountToBuy.isEmpty
                            ? '0'
                            : state.totalAmountToBuy)
                        .getThousandValueWithCurrency(
                      currency: 'USD', //TODO.. replace by real currency
                      locale: Intl.getCurrentLocale(),
                    ),
                    textAlign: TextAlign.right,
                    style: SioTextStyles.bodyPrimary.copyWith(
                      color: SioColors.secondary6,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return ColorizedAppBar(
      firstPart: context.locale.asset_buy_screen_buy,
      secondPart: context
          .locale.asset_send_summary_screen_transaction_summary_headline_second,
      actionType: ActionType.back,
      onBackTap: () {
        final state = context.read<AssetBuyFormCubit>().state;
        GoRouter.of(context).replaceNamed(
          AuthenticatedRouter.assetBuy,
          params: {
            'assetId': state.assetId.toString(),
            'networkId': state.networkId.toString(),
          },
        );
      },
    );
  }
}

class _SwipeButton extends StatelessWidget {
  const _SwipeButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: Paddings.vertical20,
        child: SwipeUpButton(
          context.locale.asset_exchange_summary_screen_confirm_btn,
          onSwipeCallback: () {
            context.read<AssetBuyFormCubit>().submitForm();
          },
        ),
      ),
    );
  }
}
