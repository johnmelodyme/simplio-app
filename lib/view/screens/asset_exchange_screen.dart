import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/helpers/thousand_separator_input_formatter.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/scroll_mixin.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_asset_item.dart';
import 'package:simplio_app/view/widgets/asset_form_exception.dart';
import 'package:simplio_app/view/widgets/asset_min_max_button.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/gradient_text_button.dart';
import 'package:simplio_app/view/widgets/highlighted_form_element.dart';
import 'package:simplio_app/view/widgets/highlighted_num_form_filed.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/toggle.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetExchangeScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetExchangeScreen({
    super.key,
    required this.sourceAssetId,
    required this.sourceNetworkId,
  });

  final String? sourceAssetId;
  final String? sourceNetworkId;

  @override
  State<StatefulWidget> createState() => _AssetExchangeScreen();
}

class _AssetExchangeScreen extends State<AssetExchangeScreen> with Scroll {
  late AssetWallet? sourceAssetWallet;
  late NetworkWallet? sourceNetworkWallet;
  late AssetWallet? targetAssetWallet;
  late NetworkWallet? targetNetworkWallet;

  final sourceValueFormController = TextEditingController();
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
    super.initState();
    if (widget.sourceAssetId == null) {
      throw Exception('No assetId provided');
    }

    if (widget.sourceNetworkId == null) {
      throw Exception('No networkId provided');
    }

    _initialAssetsSettings(context);

    amountFromHighlightController.concurrentControllers = [
      amountToHighlightController
    ];
    amountToHighlightController.concurrentControllers = [
      amountFromHighlightController
    ];
  }

  @override
  void dispose() {
    amountToHighlightController.dispose();
    amountFromHighlightController.dispose();
    sourceValueFormController.dispose();
    amountToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    if (widget.sourceAssetId == null) {
      throw Exception('No assetId');
    }

    if (widget.sourceNetworkId == null) {
      throw Exception('No networkId');
    }

    if (amountFromHighlightController.highlighted) {
      context
          .read<AssetExchangeFormCubit>()
          .changeDirection(FocusedDirection.from);
    }

    if (amountToHighlightController.highlighted) {
      context
          .read<AssetExchangeFormCubit>()
          .changeDirection(FocusedDirection.to);
    }

    return BlocListener<AssetExchangeFormCubit, AssetExchangeFormState>(
      listenWhen: (prev, curr) =>
          prev.sourceAssetWallet != curr.sourceAssetWallet ||
          prev.sourceNetworkWallet != curr.sourceNetworkWallet,
      listener: (context, state) {
        sourceAssetWallet = widget.getAssetWallet(
            context, state.sourceAssetWallet.assetId.toString());
        sourceNetworkWallet = widget.getNetwork(
            context,
            state.sourceAssetWallet.assetId.toString(),
            state.sourceNetworkWallet.networkId.toString());
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
          onPanelClosed: () {
            setState(() {
              amountFromHighlightController.deselect();
              amountToHighlightController.deselect();
            });
          },
          body: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: _NextButton(
              assetId: widget.sourceAssetId!,
              networkId: widget.sourceNetworkId!,
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColorizedAppBar(
                    firstPart:
                        context.locale.asset_exchange_screen_exchange_btn,
                    secondPart:
                        context.locale.asset_exchange_screen_coin_label_lc,
                    actionType: ActionType.close,
                  ),
                  HighlightedFormElement(
                      key: exchangeFromKey,
                      controller: amountFromHighlightController,
                      clickableHeight: 160,
                      onTap: () => setState(() {
                            amountFromHighlightController.deselectConcurrent();
                            FocusManager.instance.primaryFocus?.unfocus();
                          }),
                      children: [
                        BlocBuilder<AssetExchangeFormCubit,
                            AssetExchangeFormState>(
                          buildWhen: (prev, curr) =>
                              prev.sourceAssetWallet !=
                                  curr.sourceAssetWallet ||
                              curr.availableFromAssets.isEmpty ||
                              curr.availableFromAssets.isNotEmpty,
                          builder: (context, state) => AssetFormAssetItem<
                              AssetExchangeFormCubit, AssetExchangeFormState>(
                            isLoading: state.availableFromAssets.isEmpty,
                            highlighted:
                                amountFromHighlightController.highlighted,
                            label: context
                                .locale.asset_exchange_screen_exchange_from,
                            onTap: () {
                              GoRouter.of(context).pushNamed(
                                  AuthenticatedRouter.assetExchangeSearchFrom,
                                  params: {
                                    'assetId': widget.sourceAssetId!,
                                    'networkId': widget.sourceNetworkId!,
                                  });
                            },
                          ),
                        ),
                        _FromAmountFormField(
                          amountFromController: sourceValueFormController,
                          highlightController: amountFromHighlightController,
                          scrollController: scrollController,
                          onTap: () {
                            setState(() {
                              panelController.open();
                              _isPanelOpen = true;

                              sourceValueFormController.text = '';
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
                        BlocBuilder<AssetExchangeFormCubit,
                            AssetExchangeFormState>(
                          buildWhen: (prev, curr) =>
                              prev.targetAssetWallet !=
                                  curr.targetAssetWallet ||
                              curr.availableTargetAssets.isEmpty ||
                              curr.availableTargetAssets.isNotEmpty,
                          builder: (context, state) => AssetFormAssetItem<
                              AssetExchangeFormCubit, AssetExchangeFormState>(
                            isLoading: state.availableTargetAssets.isEmpty,
                            highlighted:
                                amountToHighlightController.highlighted,
                            label: context
                                .locale.asset_exchange_screen_exchange_to,
                            sourceAssetWalletPropertyName: 'targetAssetWallet',
                            sourceNetworkWalletPropertyName:
                                'targetNetworkWallet',
                            onTap: () => GoRouter.of(context).pushNamed(
                                AuthenticatedRouter.assetExchangeSearchTarget,
                                params: {
                                  'assetId': widget.sourceAssetId!,
                                  'networkId': widget.sourceNetworkId!,
                                }),
                          ),
                        ),
                        _TargetAmountFormField(
                          key: const ValueKey('targetAmountFormField'),
                          amountToController: amountToController,
                          highlightController: amountToHighlightController,
                          scrollController: scrollController,
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
          panel: Container(
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
                  SioColors.softBlack,
                  SioColors.backGradient4Start,
                ],
              ),
            ),
            child: Column(
              children: [
                BlocBuilder<AssetExchangeFormCubit, AssetExchangeFormState>(
                  buildWhen: (prev, curr) => prev.amountFrom != curr.amountFrom,
                  builder: (context, state) => Numpad(
                    isDecimal: true,
                    onTap: _onTap(context),
                    onErase: _onErase(context),
                    onDecimalDotTap: _onDecimalDotTap(context),
                  ),
                ),
                _NextButton(
                  assetId: widget.sourceAssetId!,
                  networkId: widget.sourceNetworkId!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ValueChanged<int> _onTap(BuildContext context) {
    return (int number) {
      final cubit = context.read<AssetExchangeFormCubit>();
      if (amountFromHighlightController.highlighted) {
        return cubit.state.amountFromUnit == AmountUnit.crypto
            ? cubit.changeFormValue(nextAmountFromDigit: number.toString())
            : cubit.changeFormValue(nextAmountFromFiatDigit: number.toString());
      } else {
        return cubit.state.amountToUnit == AmountUnit.crypto
            ? cubit.changeFormValue(nextAmountToDigit: number.toString())
            : cubit.changeFormValue(nextAmountToFiatDigit: number.toString());
      }
    };
  }

  VoidCallback _onErase(BuildContext context) {
    return context.read<AssetExchangeFormCubit>().eraseAmount;
  }

  VoidCallback _onDecimalDotTap(BuildContext context) {
    final cubit = context.read<AssetExchangeFormCubit>();
    if (amountFromHighlightController.highlighted) {
      return cubit.state.amountFromUnit == AmountUnit.crypto
          ? cubit.addDecimalDotAmountFrom
          : cubit.addDecimalDotAmountFromFiat;
    } else {
      return cubit.state.amountToUnit == AmountUnit.crypto
          ? cubit.addDecimalDotAmountTo
          : cubit.addDecimalDotAmountToFiat;
    }
  }

  void _initialAssetsSettings(BuildContext context) {
    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    final state = context.read<AssetExchangeFormCubit>().state;
    if (state.sourceAssetWallet.assetId ==
        AssetExchangeFormState.init().sourceAssetWallet.assetId) {
      sourceAssetWallet = widget.getAssetWallet(context, widget.sourceAssetId!);
    } else {
      sourceAssetWallet = state.sourceAssetWallet;
    }

    if (state.sourceNetworkWallet.networkId ==
        AssetExchangeFormState.init().sourceNetworkWallet.networkId) {
      sourceNetworkWallet = widget.getNetwork(
          context, widget.sourceAssetId!, widget.sourceNetworkId!);
    } else {
      sourceNetworkWallet = state.sourceNetworkWallet;
    }

    if (state.targetAssetWallet.assetId ==
        AssetExchangeFormState.init().targetAssetWallet.assetId) {
      targetAssetWallet = sourceAssetWallet;
    } else {
      targetAssetWallet = state.targetAssetWallet;
    }

    if (state.targetNetworkWallet.networkId ==
        AssetExchangeFormState.init().targetNetworkWallet.networkId) {
      targetNetworkWallet = sourceNetworkWallet;
    } else {
      targetNetworkWallet = state.targetNetworkWallet;
    }

    context.read<AssetExchangeFormCubit>().changeAssetWallets(
          sourceAssetWallet: sourceAssetWallet,
          sourceNetworkWallet: sourceNetworkWallet,
          targetAssetWallet: targetAssetWallet,
          targetNetworkWallet: targetNetworkWallet,
        );

    context
        .read<AssetExchangeFormCubit>()
        .loadAvailableSourcePairs(s.wallet.wallets);
  }
}

class _FromAmountFormField extends StatelessWidget {
  final TextEditingController amountFromController;
  final HighlightController highlightController;
  final ScrollController scrollController;
  final GestureTapCallback onTap;
  const _FromAmountFormField({
    required this.amountFromController,
    required this.scrollController,
    required this.onTap,
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
                prev.sourceAssetWallet != curr.sourceAssetWallet ||
                prev.amountFrom != curr.amountFrom ||
                prev.amountFromFiat != curr.amountFromFiat ||
                prev.amountFromUnit != curr.amountFromUnit ||
                curr.response is AmountFromPending ||
                curr.response is AmountFromFailure ||
                curr.response is AmountFromSuccess,
            builder: (context, state) {
              amountFromController.text = state.amountFromUnit ==
                      AmountUnit.crypto
                  ? ThousandsSeparatorInputFormatter().format(state.amountFrom)
                  : ThousandsSeparatorInputFormatter()
                      .format(state.amountFromFiat);
              final assetFormCubit = context.read<AssetExchangeFormCubit>();

              return HighlightedNumFormField(
                key: UniqueKey(),
                controller: amountFromController,
                onTap: onTap,
                suffixIconMaxWidth: 140,
                loading: state.response is AmountFromPending,
                highlighted: highlightController.highlighted,
                suffixIcon: Padding(
                  padding: Paddings.all8,
                  child: Toggle(
                    key: const ValueKey('amountFromToggle'),
                    trueOption: Text(
                      Assets.getAssetDetail(state.sourceAssetWallet.assetId)
                          .ticker,
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                    falseOption: Text(
                      'USD', // todo: use correct currency
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                    value: state.amountFromUnit == AmountUnit.crypto,
                    onChanged: (v) => assetFormCubit.changeAmountUnit(
                      amountFromUnit: v ? AmountUnit.crypto : AmountUnit.fiat,
                    ),
                  ),
                ),
              );
            },
          ),
          Gaps.gap10,
          if (highlightController.highlighted)
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              AssetMinMaxButton(
                buttonType: ButtonType.min,
                onTap: () {
                  context.read<AssetExchangeFormCubit>().minAmountClicked();
                },
              ),
              Gaps.gap20,
              AssetMinMaxButton(
                buttonType: ButtonType.max,
                onTap: () {
                  context.read<AssetExchangeFormCubit>().maxAmountClicked();
                },
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

  const _TargetAmountFormField({
    super.key,
    required this.amountToController,
    required this.scrollController,
    required this.onTap,
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
                  prev.amountToFiat != curr.amountToFiat ||
                  prev.amountToUnit != curr.amountToUnit ||
                  prev.targetAssetWallet != curr.targetAssetWallet ||
                  prev.targetNetworkWallet != curr.targetNetworkWallet ||
                  curr.response is AmountToPending ||
                  curr.response is AmountToFailure ||
                  curr.response is AmountToSuccess;
            },
            builder: (context, state) {
              amountToController.text = state.amountToUnit == AmountUnit.crypto
                  ? ThousandsSeparatorInputFormatter().format(state.amountTo)
                  : ThousandsSeparatorInputFormatter()
                      .format(state.amountToFiat);

              return HighlightedNumFormField(
                key: UniqueKey(),
                controller: amountToController,
                highlighted: highlightController.highlighted,
                onTap: onTap,
                loading: state.response is AmountToPending,
                suffixIconMaxWidth: 140,
                suffixIcon: Padding(
                  padding: Paddings.all8,
                  child: Toggle(
                    key: const ValueKey('amountToToggle'),
                    trueOption: Text(
                      Assets.getAssetDetail(state.targetAssetWallet.assetId)
                          .ticker,
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                    falseOption: Text(
                      'USD', // todo: use correct currency
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                    value: state.amountToUnit == AmountUnit.crypto,
                    onChanged: (v) => context
                        .read<AssetExchangeFormCubit>()
                        .changeAmountUnit(
                          amountToUnit: v ? AmountUnit.crypto : AmountUnit.fiat,
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
