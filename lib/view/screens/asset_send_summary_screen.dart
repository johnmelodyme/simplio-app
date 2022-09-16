import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/body_text.dart';
import 'package:simplio_app/view/widgets/choice_switch.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';
import 'package:simplio_app/view/widgets/swipe_up_button.dart';
import 'package:simplio_app/view/widgets/themed_icon.dart';

class AssetSendSummaryScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetSendSummaryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AssetSendSummaryScreen();
}

class _AssetSendSummaryScreen extends State<AssetSendSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Paddings.horizontal20,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _AppBar(),
                  _Amount(),
                  Gap(Dimensions.padding32),
                  _Fee(),
                  Gap(Dimensions.padding32),
                  _Priority(),
                  Gap(Dimensions.padding32),
                  _TotalAmount(),
                ],
              ),
              const _SwipeButton(),
            ],
          ),
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
          BodyText(context.locale.asset_send_screen_total_to_send),
          Row(
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
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  state.totalAmount, // todo: calculate correct fiat value
                  textAlign: TextAlign.right,
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
    // todo: replace with correct fee options when it's done
    final List<String> fees = [
      'Fee option 1',
      'Fee option 2',
      'Fee option 3',
      'Fee option 4',
    ];

    return BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyText(context.locale.asset_send_summary_screen_transaction_fee),
          SioExpansionRadioPanel(
            animationDuration: const Duration(milliseconds: 500),
            dividerColor: Theme.of(context).colorScheme.background,
            children: [
              ExpansionPanelRadio(
                value: UniqueKey(),
                backgroundColor: Colors.transparent,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Row(
                    children: [
                      Text(
                        '${state.cumulativeFee} ${Assets.getAssetDetail(state.assetId).ticker}',
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isExpanded
                                ? const ThemedIcon(Icons.keyboard_arrow_up)
                                : const ThemedIcon(Icons.keyboard_arrow_down),
                            const Gap(Dimensions.padding8),
                            const Text(
                              '\$170.54', // todo: calculate correct fiat value
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
                body: Column(
                  children: fees
                      .map(
                        (fee) => Padding(
                          padding: Paddings.vertical8,
                          child: Row(
                            children: [
                              Text(fee),
                              const Expanded(
                                child: Text(
                                  '\$170.54', // todo: calculate correct fiat value
                                  textAlign: TextAlign.right,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
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
      buildWhen: (prev, curr) => prev.assetId != curr.assetId,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyText(
            context.locale
                .asset_send_summary_screen_transaction_summary_amount_to_send,
          ),
          Row(
            children: [
              Text(
                '${state.amount} ${Assets.getAssetDetail(state.assetId).ticker}',
              ),
              const Expanded(
                child: Text(
                  '\$156.54', // todo: calculate correct fiat value
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Priority extends StatelessWidget {
  const _Priority();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
            context.locale.asset_send_summary_screen_set_transaction_priority),
        BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
          buildWhen: (prev, curr) => prev.priority != curr.priority,
          builder: (context, state) => ChoiceSwitch(
            value: context.read<AssetSendFormCubit>().state.priority.index,
            onChanged: (int value) {
              context
                  .read<AssetSendFormCubit>()
                  .changePriority(Priority.values[value]);
            },
            options: [
              SwitchWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                text: Text(context.locale.common_priority_low),
                icon:
                    const Icon(Icons.coffee), // todo: replace with correct icon
                defaultIconColor: Theme.of(context).colorScheme.inverseSurface,
              ),
              SwitchWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                text: Text(context.locale.common_priority_normal),
                icon: const Icon(
                    Icons.access_time_sharp), // todo: replace with correct icon
                defaultIconColor: Theme.of(context).colorScheme.tertiary,
              ),
              SwitchWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.error,
                    Theme.of(context).colorScheme.error.withOpacity(0.5),
                  ],
                ),
                text: Text(context.locale.common_priority_high),
                icon: const Icon(Icons
                    .local_fire_department), // todo: replace with correct icon
                defaultIconColor: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
      ],
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: Paddings.vertical20,
        child: SwipeUpButton(
          height: 300,
          onSwipeCallback: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).goNamed(AuthenticatedRouter.assetSendSuccess);
          },
          onSwipeStartCallback: (a, b) {},
          swipeHeight: 1000,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.rocket),
              Text(context
                  .locale.asset_send_summary_screen_swipe_up_button_label),
            ],
          ),
        ),
      ),
    );
  }
}
