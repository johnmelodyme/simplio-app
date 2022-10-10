import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_gradient_label.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';
import 'package:simplio_app/view/widgets/swipe_up_button.dart';

class AssetExchangeSummaryScreen extends StatelessWidget with WalletUtilsMixin {
  const AssetExchangeSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      const _ExchangeFrom(),
                      Gaps.gap20,
                      const _Fee(),
                      Gaps.gap20,
                      const _ExchangeTo(),
                    ],
                  ),
                ),
                const _SwipeButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExchangeTo extends StatelessWidget {
  const _ExchangeTo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_exchange_screen_exchange_to,
            style:
                SioTextStyles.bodyPrimary.copyWith(color: SioColors.secondary6),
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
                            '${state.totalAmount} ${Assets.getAssetDetail(state.assetId).ticker}',
                        style: SioTextStyles.h4.apply(
                          color: SioColors.mentolGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    state.totalAmount, // todo: calculate correct fiat value
                    textAlign: TextAlign.right,
                    style: SioTextStyles.bodyPrimary
                        .copyWith(color: SioColors.secondary6),
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

class _Fee extends StatelessWidget {
  const _Fee();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_send_summary_screen_transaction_fee,
            style:
                SioTextStyles.bodyPrimary.copyWith(color: SioColors.secondary6),
          ),
          SioExpansionRadioPanel(
            animationDuration: const Duration(milliseconds: 500),
            dividerColor: SioColors.softBlack,
            children: [
              ExpansionPanelRadio(
                value: UniqueKey(),
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Row(
                    children: [
                      Text(
                        '${state.totalSwapFee} ${Assets.getAssetDetail(state.assetId).ticker}',
                        style: SioTextStyles.bodyPrimary.apply(
                          color: SioColors.whiteBlue,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isExpanded
                                ? Icon(
                                    Icons.keyboard_arrow_up,
                                    color: SioColors.mentolGreen,
                                    size: 24,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_down,
                                    color: SioColors.mentolGreen,
                                    size: 24,
                                  ),
                            Gaps.gap10,
                            Text(
                              state
                                  .totalSwapFee, // todo: calculate correct fiat value
                              textAlign: TextAlign.right,
                              style: SioTextStyles.bodyPrimary
                                  .copyWith(color: SioColors.secondary6),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // todo: change colors when color refactoring is finished
                        SioColors.secondary1,
                        SioColors.backGradient3Start,
                      ],
                    ),
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.zero,
                      topEnd: Radius.zero,
                      bottomEnd: BorderRadii.radius20.bottomRight,
                      bottomStart: BorderRadii.radius20.bottomLeft,
                    ),
                  ),
                  padding: Paddings.all16,
                  child: Column(
                    children: [
                      Padding(
                        padding: Paddings.vertical8,
                        child: Row(
                          children: [
                            Text(
                              context.locale
                                  .asset_exchange_summary_screen_choose_target_fee,
                              style: SioTextStyles.bodyPrimary.copyWith(
                                color: SioColors.secondary7,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                state
                                    .targetTransactionFee, // todo: calculate correct fiat value
                                style: SioTextStyles.bodyPrimary.copyWith(
                                  color: SioColors.whiteBlue,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: Paddings.vertical8,
                        child: Row(
                          children: [
                            Text(
                              context.locale
                                  .asset_exchange_summary_screen_choose_source_fee,
                              style: SioTextStyles.bodyPrimary.copyWith(
                                color: SioColors.secondary7,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                state
                                    .sourceTransactionFee, // todo: calculate correct fiat value
                                style: SioTextStyles.bodyPrimary.copyWith(
                                  color: SioColors.whiteBlue,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: Paddings.vertical8,
                        child: Row(
                          children: [
                            Text(
                              context.locale
                                  .asset_exchange_summary_screen_choose_swap_fee,
                              style: SioTextStyles.bodyPrimary.copyWith(
                                color: SioColors.secondary7,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                state
                                    .swapFee, // todo: calculate correct fiat value
                                style: SioTextStyles.bodyPrimary.copyWith(
                                  color: SioColors.whiteBlue,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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

class _ExchangeFrom extends StatelessWidget {
  const _ExchangeFrom();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
      buildWhen: (prev, curr) =>
          prev.assetId != curr.assetId || prev.amountFrom != curr.amountTo,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_exchange_screen_exchange_from,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          Row(
            children: [
              Text(
                '${state.amountFrom} ${Assets.getAssetDetail(state.assetId).ticker}',
                style: SioTextStyles.bodyPrimary
                    .copyWith(color: SioColors.whiteBlue),
              ),
              Expanded(
                child: Text(
                  state.amountFrom, // todo: calculate correct fiat value
                  textAlign: TextAlign.right,
                  style: SioTextStyles.bodyPrimary
                      .copyWith(color: SioColors.secondary6),
                ),
              )
            ],
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
      firstPart: context
          .locale.asset_send_summary_screen_transaction_summary_headline_first,
      secondPart: context
          .locale.asset_send_summary_screen_transaction_summary_headline_second,
      actionType: ActionType.back,
      onBackTap: () {
        final state = context.read<AssetExchangeFormCubit>().state;
        GoRouter.of(context).replaceNamed(
          AuthenticatedRouter.assetExchange,
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
            final cubit = context.read<AssetExchangeFormCubit>();

            cubit.submitForm();
            GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetExchangeSuccess,
              params: {
                'assetId': cubit.state.assetId.toString(),
                'networkId': cubit.state.networkId.toString(),
              },
            );
          },
        ),
      ),
    );
  }
}
