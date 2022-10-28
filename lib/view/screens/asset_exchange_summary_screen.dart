import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_gradient_label.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/widgets/swipe_up_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetExchangeSummaryScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetExchangeSummaryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AssetExchangeSummaryScreen();
}

class _AssetExchangeSummaryScreen extends State<AssetExchangeSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    context
        .read<AssetExchangeFormCubit>()
        .summaryPageReadyState(accountWalletState.wallet.uuid);

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
      builder: (context, state) {
        Widget exchangeTo;
        if (state.response is FetchingFeesPending) {
          exchangeTo = RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.locale.common_loading_with_dots,
                  style: SioTextStyles.h4.apply(
                    color: SioColors.mentolGreen,
                  ),
                ),
              ],
            ),
          );
        } else {
          exchangeTo = RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${state.amountToAfterFee.toDecimalString(decimalOffset: state.targetNetworkWallet.decimalPlaces)} '
                      '${Assets.getAssetDetail(state.targetAssetWallet.assetId).ticker}',
                  style: SioTextStyles.h4.apply(
                    color: SioColors.mentolGreen,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locale.asset_exchange_screen_exchange_to,
              style: SioTextStyles.bodyPrimary
                  .copyWith(color: SioColors.secondary6),
            ),
            Gaps.gap2,
            AssetFormGradientLabel(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  exchangeTo,
                  Expanded(
                    child: Text(
                      '12.07 \$', // todo: calculate correct fiat value
                      textAlign: TextAlign.right,
                      style: SioTextStyles.bodyPrimary
                          .copyWith(color: SioColors.secondary6),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Fee extends StatelessWidget {
  const _Fee();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
      builder: (context, state) {
        Widget fee;
        if (state.response is FetchingFeesPending) {
          fee = Text(
            context.locale.common_loading_with_dots,
            style: SioTextStyles.bodyS.copyWith(
              color: SioColors.mentolGreen,
            ),
          );
        } else {
          fee = Text(
            '${state.totalSwapFee.getFormattedBalance(state.sourceNetworkWallet.decimalPlaces)} '
            '${Assets.getAssetDetail(state.networkAssetId).ticker}',
            style: SioTextStyles.bodyPrimary.apply(
              color: SioColors.whiteBlue,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locale.asset_send_summary_screen_transaction_fee,
              style: SioTextStyles.bodyPrimary
                  .copyWith(color: SioColors.secondary6),
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
                        fee,
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              isExpanded
                                  ? Icon(
                                      SioIcons.arrow_top,
                                      color: SioColors.mentolGreen,
                                      size: 24,
                                    )
                                  : Icon(
                                      SioIcons.arrow_bottom,
                                      color: SioColors.mentolGreen,
                                      size: 24,
                                    ),
                              Gaps.gap10,
                              Text(
                                '0.56 \$', // todo: calculate correct fiat value
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
                                  state.targetTransactionFee
                                      .getFormattedBalance(state
                                          .sourceNetworkWallet
                                          .decimalPlaces), // todo: calculate correct fiat value
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
                                  state.sourceTransactionFee
                                      .getFormattedBalance(state
                                          .sourceNetworkWallet
                                          .decimalPlaces), // todo: calculate correct fiat value
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
                                  state.swapFee.getFormattedBalance(state
                                      .sourceNetworkWallet
                                      .decimalPlaces), // todo: calculate correct fiat value
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
        );
      },
    );
  }
}

class _ExchangeFrom extends StatelessWidget {
  const _ExchangeFrom();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
      builder: (context, state) {
        Widget exchangeFrom;
        if (state.response is FetchingFeesPending) {
          exchangeFrom = Text(
            context.locale.common_loading_with_dots,
            style: SioTextStyles.bodyS.copyWith(
              color: SioColors.mentolGreen,
            ),
          );
        } else {
          exchangeFrom = Text(
            '${state.sourceNetworkWallet.contractAddress == null ? state.amountToSend.getFormattedBalance(state.sourceNetworkWallet.decimalPlaces) : state.amountFrom} ${Assets.getAssetDetail(state.sourceAssetWallet.assetId).ticker}',
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.whiteBlue,
            ),
          );
        }

        return Column(
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
                exchangeFrom,
                Expanded(
                  child: Text(
                    '12.63 \$', // todo: calculate correct fiat value
                    textAlign: TextAlign.right,
                    style: SioTextStyles.bodyPrimary
                        .copyWith(color: SioColors.secondary6),
                  ),
                )
              ],
            ),
          ],
        );
      },
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
            'assetId': state.sourceAssetWallet.assetId.toString(),
            'networkId': state.sourceNetworkWallet.networkId.toString(),
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
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: Paddings.vertical20,
        child: SwipeUpButton(
          context.locale.asset_exchange_summary_screen_confirm_btn,
          onSwipeCallback: () {
            final cubit = context.read<AssetExchangeFormCubit>();

            cubit.submitForm(accountWalletState.wallet.uuid);
            GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetExchangeSuccess,
              params: {
                'assetId': cubit.state.sourceAssetWallet.assetId.toString(),
                'networkId':
                    cubit.state.sourceNetworkWallet.networkId.toString(),
              },
            );
          },
        ),
      ),
    );
  }
}
