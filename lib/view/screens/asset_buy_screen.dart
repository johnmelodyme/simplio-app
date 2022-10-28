import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/helpers/thousand_separator_input_formatter.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/scroll_mixin.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_asset_item.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/gradient_text_button.dart';
import 'package:simplio_app/view/widgets/highlighted_form_element.dart';
import 'package:simplio_app/view/widgets/highlighted_num_form_filed.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/sio_dropdown.dart';
import 'package:simplio_app/view/widgets/toggle.dart';
import 'package:sio_glyphs/sio_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetBuyScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetBuyScreen({
    super.key,
    required this.assetId,
    required this.networkId,
  });

  final String? assetId;
  final String? networkId;

  @override
  State<StatefulWidget> createState() => _AssetBuyScreen();
}

class _AssetBuyScreen extends State<AssetBuyScreen> with Scroll {
  final amountController = TextEditingController();
  final amountHighlightController = HighlightController();
  final assetHighlightController = HighlightController();
  final paymentMethodHighlightController = HighlightController();

  final PanelController panelController = PanelController();
  final ScrollController scrollController = ScrollController();

  final assetKey = GlobalKey();
  final paymentMethodKey = GlobalKey();
  final amountKey = GlobalKey();

  int selectedPaymentIndex = -1;

  bool _isPanelOpen = false;

  @override
  void initState() {
    amountHighlightController.concurrentControllers = [
      assetHighlightController,
      paymentMethodHighlightController,
    ];
    assetHighlightController.concurrentControllers = [
      amountHighlightController,
      paymentMethodHighlightController,
    ];
    paymentMethodHighlightController.concurrentControllers = [
      amountHighlightController,
      assetHighlightController,
    ];
    super.initState();
  }

  @override
  void dispose() {
    assetHighlightController.dispose();
    amountHighlightController.dispose();
    paymentMethodHighlightController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late AssetWallet? sourceAssetWallet;
    late NetworkWallet? sourceNetworkWallet;

    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    if (widget.assetId == null) {
      throw Exception('No assetId');
    }

    if (widget.networkId == null) {
      throw Exception('No networkId');
    }

    sourceAssetWallet = widget.getAssetWallet(context, widget.assetId!);
    sourceNetworkWallet =
        widget.getNetwork(context, widget.assetId!, widget.networkId!);

    context.read<AssetBuyFormCubit>().changeFormValue(
          sourceAssetWallet: sourceAssetWallet,
          sourceNetworkWallet: sourceNetworkWallet,
        );

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
              amountHighlightController.deselect();
              assetHighlightController.deselect();
              paymentMethodHighlightController.deselect();
              panelController.close();
            });
            FocusManager.instance.primaryFocus?.unfocus();
            scrollTo(assetKey, 50);
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
                      firstPart: context.locale.asset_buy_screen_buy,
                      secondPart:
                          context.locale.asset_exchange_screen_coin_label_lc,
                      actionType: ActionType.close,
                    ),
                    HighlightedFormElement(
                        key: assetKey,
                        controller: assetHighlightController,
                        clickableHeight: 100,
                        onTap: () => setState(() {
                              assetHighlightController.deselectConcurrent();
                              FocusManager.instance.primaryFocus?.unfocus();
                            }),
                        children: [
                          BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
                            buildWhen: (prev, curr) =>
                                prev.sourceAssetWallet !=
                                curr.sourceAssetWallet,
                            builder: (context, state) => AssetFormAssetItem<
                                AssetBuyFormCubit, AssetBuyFormState>(
                              highlighted: assetHighlightController.highlighted,
                              label:
                                  context.locale.asset_buy_screen_what_you_buy,
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                    AuthenticatedRouter.assetBuySearch,
                                    params: {
                                      'assetId': widget.assetId!,
                                      'networkId': widget.networkId!,
                                    });
                              },
                            ),
                          ),
                        ]),
                    HighlightedFormElement(
                        key: paymentMethodKey,
                        controller: paymentMethodHighlightController,
                        clickableHeight: 100,
                        onTap: () => setState(() {
                              paymentMethodHighlightController
                                  .deselectConcurrent();
                              FocusManager.instance.primaryFocus?.unfocus();
                            }),
                        children: [
                          Gaps.gap10,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.locale
                                  .asset_buy_screen_choose_payment_method,
                              style: SioTextStyles.bodyL.apply(
                                color:
                                    paymentMethodHighlightController.highlighted
                                        ? SioColors.mentolGreen
                                        : SioColors.secondary7,
                              ),
                            ),
                          ),
                          Gaps.gap5,
                          SioDropdown(
                            placeholder: Row(
                              children: [
                                Icon(
                                  SioIcons.credit_card,
                                  size: 35,
                                  color: SioColors.secondary7,
                                ),
                                Gaps.gap12,
                                Text(
                                  context
                                      .locale.asset_buy_screen_use_debit_card,
                                  style: SioTextStyles.bodyPrimary.copyWith(
                                    color: SioColors.secondary7,
                                  ),
                                ),
                              ],
                            ),
                            highlightController:
                                paymentMethodHighlightController,
                            selectedIndex: selectedPaymentIndex,
                            itemSelectedCallback: (int selectedIndex) =>
                                setState(
                                    () => selectedPaymentIndex = selectedIndex),
                          ),
                          Gaps.gap8,
                        ]),
                    HighlightedFormElement(
                      key: amountKey,
                      controller: amountHighlightController,
                      clickableHeight: 80,
                      onTap: () => setState(() {
                        amountHighlightController.deselectConcurrent();
                        amountHighlightController.select();
                      }),
                      children: [
                        BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
                          buildWhen: (prev, curr) =>
                              prev.sourceAssetWallet != curr.sourceAssetWallet,
                          builder: (context, state) => _AmountFormField(
                            amountController: amountController,
                            scrollController: scrollController,
                            onTap: () {
                              setState(() {
                                panelController.open();
                                _isPanelOpen = true;
                              });

                              scrollTo(amountKey, -50);
                            },
                            assetId: state.sourceAssetWallet.assetId,
                            highlightController: amountHighlightController,
                          ),
                        ),
                      ],
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
                SioColors.softBlack,
                SioColors.backGradient4Start,
              ],
            ),
          ),
          child: Column(
            children: [
              BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
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
      final cubit = context.read<AssetBuyFormCubit>();
      return cubit.state.amountUnit == AmountUnit.crypto
          ? cubit.changeFormValue(nextAmountDigit: number.toString())
          : cubit.changeFormValue(nextAmountFiatDigit: number.toString());
    };
  }

  VoidCallback _onErase(BuildContext context) {
    final cubit = context.read<AssetBuyFormCubit>();
    return cubit.state.amountUnit == AmountUnit.crypto
        ? cubit.eraseAmountFrom
        : cubit.eraseAmountFromFiat;
  }

  VoidCallback _onDecimalDotTap(BuildContext context) {
    final cubit = context.read<AssetBuyFormCubit>();
    return cubit.state.amountUnit == AmountUnit.crypto
        ? cubit.addDecimalDotAmountFrom
        : cubit.addDecimalDotAmountFromFiat;
  }
}

class _AmountFormField extends StatelessWidget {
  final TextEditingController amountController;
  final HighlightController highlightController;
  final ScrollController scrollController;
  final GestureTapCallback onTap;
  final int assetId;
  const _AmountFormField({
    required this.amountController,
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
          BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
            buildWhen: (prev, curr) =>
                prev.amount != curr.amount ||
                prev.amountFiat != curr.amountFiat ||
                prev.amountUnit != curr.amountUnit ||
                curr.response is AmountPending ||
                curr.response is AmountFailure ||
                curr.response is AmountSuccess,
            builder: (context, state) {
              amountController.text = state.amountUnit == AmountUnit.crypto
                  ? ThousandsSeparatorInputFormatter().format(state.amount)
                  : ThousandsSeparatorInputFormatter().format(state.amountFiat);
              final assetFormCubit = context.read<AssetBuyFormCubit>();

              return HighlightedNumFormField(
                controller: amountController,
                onTap: onTap,
                suffixIconMaxWidth: 140,
                loading: state.response is AmountPending,
                highlighted: highlightController.highlighted,
                suffixIcon: Padding(
                  padding: Paddings.all8,
                  child: Toggle(
                    trueOption: Text(
                      Assets.getAssetDetail(assetId).ticker,
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
                    value: state.amountUnit == AmountUnit.crypto,
                    onChanged: (value) => assetFormCubit.changeAmountUnit(
                        value ? AmountUnit.crypto : AmountUnit.fiat),
                  ),
                ),
              );
            },
          ),
          Gaps.gap10,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
                buildWhen: (prev, curr) =>
                    prev.amount != curr.amount ||
                    prev.amountFiat != curr.amountFiat ||
                    prev.amountUnit != curr.amountUnit,
                builder: (context, state) =>
                    state.amountUnit == AmountUnit.crypto
                        ? Text(
                            double.parse(state.amountFiat.isEmpty
                                    ? '0'
                                    : state.amountFiat)
                                .getThousandValueWithCurrency(
                              currency: 'USD', //TODO.. replace by real currency
                              locale: Intl.getCurrentLocale(),
                            ),
                            style: SioTextStyles.bodyL.copyWith(
                              color: SioColors.secondary7,
                            ),
                          )
                        : Text(
                            '${state.amount.isEmpty ? '0' : state.amount} ${Assets.getAssetDetail(state.sourceAssetWallet.assetId).ticker}',
                            style: SioTextStyles.bodyL.copyWith(
                              color: SioColors.secondary7,
                            ),
                          ),
              ),
            ],
          ),
          Gaps.gap5,
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
      child: BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
        buildWhen: (prev, curr) => prev.isValid != curr.isValid,
        builder: (context, state) => GradientTextButton(
          context.locale.asset_send_screen_summary_btn_label,
          enabled: state.isValid,
          onPressed: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).pushNamed(
              AuthenticatedRouter.assetBuySummary,
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
