import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/helpers/thousand_separator_input_formatter.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/scroll_mixin.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/asset_form_asset_item.dart';
import 'package:simplio_app/view/widgets/asset_form_exception.dart';
import 'package:simplio_app/view/widgets/asset_min_max_button.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/gradient_text_button.dart';
import 'package:simplio_app/view/widgets/highlighted_form_element.dart';
import 'package:simplio_app/view/widgets/highlighted_num_form_filed.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/toggle.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetExchangeScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetExchangeScreen({
    super.key,
    required this.assetId,
    required this.networkId,
  });

  final String? assetId;
  final String? networkId;

  @override
  State<StatefulWidget> createState() => _AssetExchangeScreen();
}

class _AssetExchangeScreen extends State<AssetExchangeScreen> with Scroll {
  final amountFromController = TextEditingController();
  final amountFromHighlightController = HighlightController();

  final amountToController = TextEditingController();
  final amountToHighlightController = HighlightController();

  final PanelController panelController = PanelController();
  final ScrollController scrollController = ScrollController();

  final exchangeFromKey = GlobalKey();
  final exchangeToKey = GlobalKey();

  bool _isPanelOpen = false;

  @override
  void initState() {
    amountFromHighlightController.concurrentControllers = [
      amountToHighlightController
    ];
    amountToHighlightController.concurrentControllers = [
      amountFromHighlightController
    ];
    super.initState();
  }

  @override
  void dispose() {
    amountToHighlightController.dispose();
    amountFromHighlightController.dispose();
    amountFromController.dispose();
    amountToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    if (widget.assetId == null) {
      throw Exception('No assetId');
    }

    if (widget.networkId == null) {
      throw Exception('No networkId');
    }

    final assetExchangeState = context.read<AssetExchangeFormCubit>().state;
    if (assetExchangeState.assetId ==
        const AssetExchangeFormState.init().assetId) {
      context.read<AssetExchangeFormCubit>().changeFormValue(
            assetId: int.parse(widget.assetId!),
            networkId: int.parse(widget.networkId!),
          );

      context.read<AssetExchangeFormCubit>().onFromAssetChange(
            assetId: int.parse(widget.assetId!),
            networkId: int.parse(widget.networkId!),
            availableWallets: s.wallet.wallets,
          );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer,
            Theme.of(context).colorScheme.background,
          ],
        ),
      ),
      child: SlidingUpPanel(
        controller: panelController,
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusSize.radius20),
          topRight: Radius.circular(RadiusSize.radius20),
        ),
        boxShadow: null,
        minHeight: 0,
        maxHeight: Constants.panelKeyboardHeightWithButton,
        body: GestureDetector(
          onTap: () {
            // handle clicks to the background
            setState(() {
              amountFromHighlightController.deselect();
              amountToHighlightController.deselect();
              panelController.close();
            });
            FocusManager.instance.primaryFocus?.unfocus();
            scrollTo(exchangeFromKey, 50);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: _NextButton(
              assetId: widget.assetId!,
              networkId: widget.networkId!,
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    panelController.close();
                    _isPanelOpen = false;
                  });

                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ColorizedAppBar(
                      firstPart:
                          context.locale.asset_exchange_screen_exchange_btn,
                      secondPart:
                          context.locale.asset_exchange_screen_coin_label_lc,
                      actionType: ActionType.close,
                      onBackTap: () => GoRouter.of(context).pop(),
                    ),
                    HighlightedFormElement(
                        key: exchangeFromKey,
                        controller: amountFromHighlightController,
                        clickableHeight: 160,
                        onTap: () => setState(() {
                              amountFromHighlightController
                                  .deselectConcurrent();
                              FocusManager.instance.primaryFocus?.unfocus();
                            }),
                        children: [
                          BlocBuilder<AssetExchangeFormCubit,
                              AssetExchangeFormState>(
                            buildWhen: (prev, curr) =>
                                prev.assetId != curr.assetId,
                            builder: (context, state) => AssetFormAssetItem<
                                AssetExchangeFormCubit, AssetExchangeFormState>(
                              highlighted:
                                  amountFromHighlightController.highlighted,
                              label: context
                                  .locale.asset_exchange_screen_exchange_from,
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                    AuthenticatedRouter.assetExchangeSearchFrom,
                                    params: {
                                      'assetId': widget.assetId!,
                                      'networkId': widget.networkId!,
                                    });
                              },
                            ),
                          ),
                          _FromAmountFormField(
                            amountFromController: amountFromController,
                            highlightController: amountFromHighlightController,
                            scrollController: scrollController,
                            assetId: int.parse(widget.assetId!),
                            onTap: () {
                              setState(() {
                                panelController.open();
                                _isPanelOpen = true;

                                amountFromController.text = '';
                              });

                              scrollTo(exchangeFromKey, 50);
                            },
                          ),
                          Gaps.gap8,
                        ]),
                    if (amountFromHighlightController.highlighted)
                      Container(
                        padding: Paddings.left16,
                        child: const AssetFormException<AssetExchangeFormCubit,
                            AssetExchangeFormState>(
                          formElementIndex: 0,
                        ),
                      ),
                    HighlightedFormElement(
                        key: exchangeToKey,
                        controller: amountToHighlightController,
                        onTap: () => setState(() {
                              amountToHighlightController.deselectConcurrent();
                              amountToHighlightController.select();
                            }),
                        clickableHeight: 160,
                        children: [
                          AssetFormAssetItem<AssetExchangeFormCubit,
                              AssetExchangeFormState>(
                            highlighted:
                                amountToHighlightController.highlighted,
                            label: context
                                .locale.asset_exchange_screen_exchange_to,
                            assetIdPropertyName: 'targetAssetId',
                            networkIdPropertyName: 'targetNetworkId',
                            onTap: () => GoRouter.of(context).pushNamed(
                                AuthenticatedRouter.assetExchangeSearchTarget,
                                params: {
                                  'assetId': widget.assetId!,
                                  'networkId': widget.networkId!,
                                }),
                          ),
                          _TargetAmountFormField(
                            amountToController: amountToController,
                            highlightController: amountToHighlightController,
                            scrollController: scrollController,
                            assetId: int.parse(widget.assetId!),
                            onTap: () {
                              setState(() {
                                panelController.open();
                                _isPanelOpen = true;
                              });

                              scrollTo(exchangeToKey, -50);
                            },
                          ),
                          Gaps.gap16,
                        ]),
                    if (amountToHighlightController.highlighted)
                      Container(
                        padding: Paddings.left16,
                        child: const AssetFormException<AssetExchangeFormCubit,
                            AssetExchangeFormState>(
                          formElementIndex: 1,
                        ),
                      ),
                    if (_isPanelOpen)
                      const SizedBox(
                        height: Constants.panelKeyboardHeightWithButton,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        panel: Container(
          padding: Paddings.vertical16,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: BorderRadii.radius20.topLeft,
              topEnd: BorderRadii.radius20.topLeft,
              bottomEnd: Radius.zero,
              bottomStart: Radius.zero,
            ),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.onPrimaryContainer,
              ],
            ),
          ),
          child: Column(
            children: [
              BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
                buildWhen: (prev, curr) => prev.amountUnit != curr.amountUnit,
                builder: (context, state) => Numpad(
                  isDecimal: true,
                  onTap: _onTap(context),
                  onErase: _onErase(context),
                  onDecimalDotTap: _onDecimalDotTap(context),
                ),
              ),
              _NextButton(
                assetId: widget.assetId!,
                networkId: widget.networkId!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ValueChanged<int> _onTap(BuildContext context) {
    return (number) {
      final cubit = context.read<AssetExchangeFormCubit>();
      if (amountFromHighlightController.highlighted) {
        return cubit.state.amountUnit == AmountUnit.crypto
            ? cubit.changeFormValue(nextAmountFromDigit: number.toString())
            : cubit.changeFormValue(nextAmountFromFiatDigit: number.toString());
      } else {
        return cubit.changeFormValue(nextAmountToDigit: number.toString());
      }
    };
  }

  VoidCallback _onErase(BuildContext context) {
    final cubit = context.read<AssetExchangeFormCubit>();
    if (amountFromHighlightController.highlighted) {
      return cubit.state.amountUnit == AmountUnit.crypto
          ? cubit.eraseAmountFrom
          : cubit.eraseAmountFromFiat;
    } else {
      return cubit.eraseAmountTo;
    }
  }

  VoidCallback _onDecimalDotTap(BuildContext context) {
    final cubit = context.read<AssetExchangeFormCubit>();
    if (amountFromHighlightController.highlighted) {
      return cubit.state.amountUnit == AmountUnit.crypto
          ? cubit.addDecimalDotAmountFrom
          : cubit.addDecimalDotAmountFromFiat;
    } else {
      return cubit.addDecimalDotAmountTo;
    }
  }
}

class _FromAmountFormField extends StatelessWidget {
  final TextEditingController amountFromController;
  final HighlightController highlightController;
  final ScrollController scrollController;
  final GestureTapCallback onTap;
  final int assetId;
  const _FromAmountFormField({
    required this.amountFromController,
    required this.scrollController,
    required this.onTap,
    required this.assetId,
    required this.highlightController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.top5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
            buildWhen: (prev, curr) =>
                prev.amountFrom != curr.amountFrom ||
                prev.amountFromFiat != curr.amountFromFiat ||
                prev.amountUnit != curr.amountUnit ||
                curr.response is AmountFromPending ||
                curr.response is AmountFromFailure ||
                curr.response is AmountFromSuccess,
            builder: (context, state) {
              amountFromController.text = state.amountUnit == AmountUnit.crypto
                  ? ThousandsSeparatorInputFormatter().format(state.amountFrom)
                  : ThousandsSeparatorInputFormatter()
                      .format(state.amountFromFiat);
              final assetFormCubit = context.read<AssetExchangeFormCubit>();

              return HighlightedNumFormField(
                controller: amountFromController,
                onTap: onTap,
                suffixIconMaxWidth: 140,
                loading: state.response is AmountFromPending,
                highlighted: highlightController.highlighted,
                suffixIcon: Padding(
                  padding: Paddings.all8,
                  child: Toggle(
                    trueOption: Text(
                      Assets.getAssetDetail(assetId).ticker,
                      style: SioTextStyles.bodyS.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    falseOption: Text(
                      'USD', // todo: use correct currency
                      style: SioTextStyles.bodyS.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    value: state.amountUnit == AmountUnit.crypto,
                    onChanged: (value) => assetFormCubit.changeAmountUnit(
                        value ? AmountUnit.crypto : AmountUnit.fiat),
                  ),
                ),
              );
            },
          ),
          Gaps.gap10,
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            AssetMinMaxButton(
              buttonType: ButtonType.min,
              onTap: context.read<AssetExchangeFormCubit>().minAmountClicked,
            ),
            Gaps.gap20,
            AssetMinMaxButton(
              buttonType: ButtonType.max,
              onTap: context.read<AssetExchangeFormCubit>().maxAmountClicked,
            ),
          ]),
        ],
      ),
    );
  }
}

class _TargetAmountFormField extends StatelessWidget {
  final TextEditingController amountToController;
  final HighlightController highlightController;
  final ScrollController scrollController;

  final GestureTapCallback onTap;
  final int assetId;
  const _TargetAmountFormField({
    required this.amountToController,
    required this.scrollController,
    required this.onTap,
    required this.assetId,
    required this.highlightController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.top5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
            buildWhen: (prev, curr) {
              return prev.amountTo != curr.amountTo ||
                  prev.assetId != curr.assetId ||
                  curr.response is AmountToPending ||
                  curr.response is AmountToFailure ||
                  curr.response is AmountToSuccess;
            },
            builder: (context, state) {
              amountToController.text =
                  ThousandsSeparatorInputFormatter().format(state.amountTo);

              return HighlightedNumFormField(
                controller: amountToController,
                highlighted: highlightController.highlighted,
                onTap: onTap,
                loading: state.response is AmountToPending,
                suffixIconMaxWidth: 70,
                suffixIcon: Padding(
                  padding: Paddings.all8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadii.radius64,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadii.radius64,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.center,
                                colors: [
                                  Theme.of(context).colorScheme.background,
                                  Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withOpacity(0),
                                ],
                              ),
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                            ),
                            child: Toggle(
                              trueOption: Text(
                                Assets.getAssetDetail(assetId).ticker,
                                style: SioTextStyles.bodyS.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final String assetId;
  final String networkId;

  const _NextButton({
    required this.assetId,
    required this.networkId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.all20,
      child: BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
        buildWhen: (prev, curr) => prev.isValid != curr.isValid,
        builder: (context, state) => GradientTextButton(
          context.locale.asset_send_screen_summary_btn_label,
          enabled: state.isValid,
          onPressed: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).pushNamed(
              AuthenticatedRouter.assetExchangeSummary,
              params: {
                'assetId': assetId,
                'networkId': networkId,
              },
            );
          },
        ),
      ),
    );
  }
}
