import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart'
    as send_cubit;
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/helpers/thousand_separator_input_formatter.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/screens/mixins/scroll_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_form_asset_item.dart';
import 'package:simplio_app/view/widgets/asset_form_exception.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/gradient_text_button.dart';
import 'package:simplio_app/view/widgets/highlighted_form_element.dart';
import 'package:simplio_app/view/widgets/highlighted_num_form_filed.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/sio_dropdown.dart';
import 'package:simplio_app/view/widgets/toggle.dart';
import 'package:sio_glyphs/sio_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetBuyScreen extends StatefulWidget {
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

class _AssetBuyScreen extends State<AssetBuyScreen>
    with Scroll, PopupDialogMixin {
  final amountController = TextEditingController();
  final amountHighlightController = HighlightController();

  final PanelController panelController = PanelController();
  final ScrollController scrollController = ScrollController();

  final assetKey = GlobalKey();
  final paymentMethodKey = GlobalKey();
  final amountKey = GlobalKey();

  int selectedPaymentIndex = -1;

  bool _isPanelOpen = false;

  @override
  void initState() {
    super.initState();
    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    context.read<AssetBuyFormCubit>().loadAvailableAssetsToBuy(
          assetId: int.parse(widget.assetId!),
          networkId: int.parse(widget.networkId!),
          availableWallets: s.wallet.wallets,
        );
  }

  @override
  void dispose() {
    amountHighlightController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetId == null) {
      throw Exception('No assetId');
    }

    if (widget.networkId == null) {
      throw Exception('No networkId');
    }

    return BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
      listener: (context, state) {
        final response = state.response;
        if (response is AssetSearchFailure) {
          showError(
            context,
            message: context.locale.common_error,
            afterHideAction: () => GoRouter.of(context).pop(),
          );
        }
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
              amountHighlightController.deselect();
              FocusManager.instance.primaryFocus?.unfocus();
            });
          },
          body: Scaffold(
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
                    Padding(
                      padding: Paddings.horizontal16,
                      child: BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
                        buildWhen: (prev, curr) =>
                            prev.response != curr.response ||
                            prev.sourceNetworkWallet !=
                                curr.sourceNetworkWallet ||
                            prev.sourceAssetWallet != curr.sourceAssetWallet,
                        builder: (context, state) => AssetFormAssetItem<
                            AssetBuyFormCubit, AssetBuyFormState>(
                          isLoading: state.response is AssetSearchLoading,
                          highlighted: false,
                          sourceAssetWalletPropertyName: 'sourceAssetWallet',
                          sourceNetworkWalletPropertyName:
                              'sourceNetworkWallet',
                          label: context.locale.asset_buy_screen_what_you_buy,
                        ),
                      ),
                    ),
                    Padding(
                      padding: Paddings.horizontal16,
                      child: Column(
                        children: [
                          Gaps.gap10,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.locale
                                  .asset_buy_screen_choose_payment_method,
                              style: SioTextStyles.bodyL.apply(
                                color: SioColors.secondary7,
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
                            // highlightController: paymentMethodHighlightController,
                            selectedIndex: selectedPaymentIndex,
                            itemSelectedCallback: (int selectedIndex) =>
                                setState(
                                    () => selectedPaymentIndex = selectedIndex),
                          ),
                          Gaps.gap8,
                        ],
                      ),
                    ),
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
                    if (amountHighlightController.highlighted)
                      Container(
                        padding: Paddings.left16,
                        child: const AssetFormException<AssetBuyFormCubit,
                            AssetBuyFormState>(
                          formElementIndex: 0,
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
      ),
    );
  }

  ValueChanged<int> _onTap(BuildContext context) {
    return (number) {
      final cubit = context.read<AssetBuyFormCubit>();
      return cubit.state.amountUnit == send_cubit.AmountUnit.crypto
          ? cubit.changeFormValue(nextAmountDigit: number.toString())
          : cubit.changeFormValue(nextAmountFiatDigit: number.toString());
    };
  }

  VoidCallback _onErase(BuildContext context) {
    final cubit = context.read<AssetBuyFormCubit>();
    return cubit.state.amountUnit == send_cubit.AmountUnit.crypto
        ? cubit.eraseAmount
        : cubit.eraseAmountFiat;
  }

  VoidCallback _onDecimalDotTap(BuildContext context) {
    final cubit = context.read<AssetBuyFormCubit>();
    return cubit.state.amountUnit == send_cubit.AmountUnit.crypto
        ? cubit.addDecimalDotAmount
        : cubit.addDecimalDotAmountFiat;
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
                prev.amountUnit != curr.amountUnit,
            builder: (context, state) {
              amountController.text = state.amountUnit ==
                      send_cubit.AmountUnit.crypto
                  ? ThousandsSeparatorInputFormatter().format(state.amount)
                  : ThousandsSeparatorInputFormatter().format(state.amountFiat);
              // final assetFormCubit = context.read<AssetBuyFormCubit>();

              return HighlightedNumFormField(
                controller: amountController,
                onTap: onTap,
                suffixIconMaxWidth: 140,
                highlighted: highlightController.highlighted,
                suffixIcon: Padding(
                  padding: Paddings.all8,
                  child: Toggle(
                    trueOption: Text(
                      'USD', // todo: use correct currency
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.whiteBlue,
                      ),
                    ),
                    value: true,
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
                    prev.amountUnit != curr.amountUnit ||
                    curr.response is AmountSuccess ||
                    curr.response is AmountFailure ||
                    curr.response is AmountPending,
                builder: (context, state) {
                  if (state.response is AmountPending) {
                    return Text(
                      context.locale.common_loading_with_dots,
                      style: SioTextStyles.bodyS.copyWith(
                        color: SioColors.mentolGreen,
                      ),
                    );
                  }

                  return state.amountUnit == send_cubit.AmountUnit.crypto
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
                        );
                },
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
