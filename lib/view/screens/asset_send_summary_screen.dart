import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_exception.dart';
import 'package:simplio_app/view/widgets/asset_form_gradient_label.dart';
import 'package:simplio_app/view/widgets/choice_switch.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/swipe_up_button.dart';

class AssetSendSummaryScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetSendSummaryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AssetSendSummaryScreen();
}

class _AssetSendSummaryScreen extends State<AssetSendSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    context
        .read<AssetSendFormCubit>()
        .builtTxState(accountWalletState.wallet.uuid);

    return BlocListener<AssetSendFormCubit, AssetSendFormState>(
      listenWhen: (prev, curr) => curr.response is AssetSendFormPending,
      listener: (context, state) {
        GoRouter.of(context)
            .replaceNamed(AuthenticatedRouter.assetSendSuccess, params: {
          'assetId': state.assetId.toString(),
          'networkId': state.networkId.toString(),
        });
      },
      child: Container(
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
                children: [
                  Padding(
                    padding: Paddings.horizontal20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Amount(),
                        Gaps.gap32,
                        const _Fee(),
                        Gaps.gap32,
                        const _Priority(),
                        Gaps.gap32,
                        const _TotalAmount(),
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
    );
  }
}

class _TotalAmount extends StatelessWidget {
  const _TotalAmount();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_send_screen_total_to_send,
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
                    '\$327.08', // todo: calculate correct fiat value
                    textAlign: TextAlign.right,
                    style: SioTextStyles.bodyPrimary.apply(
                      color: SioColors.whiteBlue,
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

class _Fee extends StatelessWidget {
  const _Fee();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
      buildWhen: (prev, curr) =>
          prev.networkId != curr.networkId ||
          prev.networkFee != curr.networkFee,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_send_summary_screen_transaction_fee,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          Row(
            children: [
              Text(
                '${state.networkFee} ${Assets.getAssetDetail(state.networkId).ticker}',
                style: SioTextStyles.bodyPrimary.copyWith(
                  color: SioColors.whiteBlue,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '\$170.54', // todo: calculate correct fiat value
                      style: SioTextStyles.bodyPrimary.copyWith(
                        color: SioColors.secondary6,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
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
            '${state.networkWallet.contractAddress == null ? state.amountToSend(state.networkWallet.decimalPlaces).getFormattedBalance(state.networkWallet.decimalPlaces).toString() : state.amount} ${Assets.getAssetDetail(state.assetId).ticker}',
            style: SioTextStyles.bodyPrimary.apply(color: SioColors.whiteBlue),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locale
                  .asset_send_summary_screen_transaction_summary_amount_to_send,
              style: SioTextStyles.bodyPrimary.copyWith(
                color: SioColors.secondary6,
              ),
            ),
            Gaps.gap2,
            Row(
              children: [
                fee,
                Expanded(
                  child: Text(
                    '\$156.54', // todo: calculate correct fiat value
                    style: SioTextStyles.bodyPrimary.copyWith(
                      color: SioColors.secondary6,
                    ),
                    textAlign: TextAlign.right,
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

class _Priority extends StatelessWidget {
  const _Priority();

  @override
  Widget build(BuildContext context) {
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      throw Exception('No AccountWallet Provided');
      // todo: add notification for the user when the snackbar task is done
    }

    return BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
      buildWhen: (prev, curr) => prev.priority != curr.priority,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_send_summary_screen_set_transaction_priority,
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.secondary6,
            ),
          ),
          Gaps.gap2,
          BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
            buildWhen: (prev, curr) => prev.priority != curr.priority,
            builder: (context, state) => ChoiceSwitch(
              value: context.read<AssetSendFormCubit>().state.priority.index,
              onChanged: (int value) {
                context
                    .read<AssetSendFormCubit>()
                    .changePriority(Priority.values[value]);
                context
                    .read<AssetSendFormCubit>()
                    .builtTxState(accountWalletState.wallet.uuid);
              },
              options: [
                SwitchWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      SioColors.highlight1,
                      SioColors.vividBlue,
                    ],
                  ),
                  text: Text(
                    context.locale.common_priority_low,
                    style: SioTextStyles.bodyLargeBold,
                  ),
                  icon: const Icon(
                      Icons.coffee), // todo: replace with correct icon
                  defaultIconColor: SioColors.mentolGreen,
                ),
                SwitchWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      SioColors.highlight1,
                      SioColors.vividBlue,
                    ],
                  ),
                  text: Text(
                    context.locale.common_priority_normal,
                    style: SioTextStyles.bodyLargeBold,
                  ),
                  icon: const Icon(Icons
                      .access_time_sharp), // todo: replace with correct icon
                  defaultIconColor: SioColors.vividBlue,
                ),
                SwitchWidget(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      SioColors.attentionGradient,
                      SioColors.attention,
                    ],
                  ),
                  text: Text(
                    context.locale.common_priority_high,
                    style: SioTextStyles.bodyLargeBold,
                  ),
                  icon: const Icon(Icons
                      .local_fire_department), // todo: replace with correct icon
                  defaultIconColor: SioColors.attention,
                ),
              ],
            ),
          ),
          const AssetFormException<AssetSendFormCubit, AssetSendFormState>(
            formElementIndex: 1,
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
    return BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
      buildWhen: (prev, curr) => prev != curr,
      builder: (context, state) => ColorizedAppBar(
        firstPart: context.locale
            .asset_send_summary_screen_transaction_summary_headline_first,
        secondPart: context.locale
            .asset_send_summary_screen_transaction_summary_headline_second,
        actionType: ActionType.back,
        onBackTap: () {
          GoRouter.of(context).replaceNamed(
            AuthenticatedRouter.assetSend,
            params: {
              'assetId': state.assetId.toString(),
              'networkId': state.networkId.toString(),
            },
            extra: state,
          );
        },
      ),
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
          context.locale.asset_send_summary_screen_swipe_up_button_label,
          onSwipeCallback: () {
            context
                .read<AssetSendFormCubit>()
                .submitForm(accountWalletState.wallet.uuid);
          },
        ),
      ),
    );
  }
}
