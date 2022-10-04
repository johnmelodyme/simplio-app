import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
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
import 'package:simplio_app/view/widgets/highlighted_form_element.dart';
import 'package:simplio_app/view/widgets/highlighted_num_form_filed.dart';
import 'package:simplio_app/view/widgets/highlighted_text_form_filed.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/qr_code_scanner.dart';
import 'package:simplio_app/view/widgets/toggle.dart';
import 'package:simplio_app/view/widgets/gradient_text_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AssetSendScreen extends StatefulWidget with WalletUtilsMixin {
  const AssetSendScreen({
    super.key,
    required this.assetId,
    required this.networkId,
  });

  final String? assetId;
  final String? networkId;

  @override
  State<StatefulWidget> createState() => _AssetSendScreen();
}

class _AssetSendScreen extends State<AssetSendScreen> with Scroll {
  bool displayQrCode = false;

  late AssetWallet? assetWallet;
  late NetworkWallet? networkWallet;

  final addressController = TextEditingController();
  final addressHighlightController = HighlightController();

  final amountController = TextEditingController();
  final amountHighlightController = HighlightController();

  final assetHighlightController = HighlightController();

  final PanelController panelController = PanelController();
  final ScrollController scrollController = ScrollController();

  final assetKey = GlobalKey();
  final addressKey = GlobalKey();
  final amountKey = GlobalKey();

  bool _isPanelOpen = false;

  @override
  void initState() {
    if (widget.assetId == null) {
      throw Exception('No assetId provided');
    }

    if (widget.networkId == null) {
      throw Exception('No networkId provided');
    }

    assetWallet = widget.getAssetWallet(context, widget.assetId!);
    networkWallet =
        widget.getNetwork(context, widget.assetId!, widget.networkId!);

    context.read<AssetSendFormCubit>().changeFormValue(
          assetId: int.parse(widget.assetId!),
          networkId: int.parse(widget.networkId!),
          networkWallet: networkWallet,
        );

    assetHighlightController.concurrentControllers = [
      addressHighlightController,
      amountHighlightController,
    ];
    addressHighlightController.concurrentControllers = [
      assetHighlightController,
      amountHighlightController,
    ];
    amountHighlightController.concurrentControllers = [
      assetHighlightController,
      addressHighlightController,
    ];

    super.initState();
  }

  @override
  void dispose() {
    addressController.dispose();
    addressHighlightController.dispose();

    amountController.dispose();
    amountHighlightController.dispose();

    assetHighlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    final AssetSendFormCubit assetSendCubit =
        context.read<AssetSendFormCubit>();
    if (assetSendCubit.state.assetId == AssetSendFormState.init().assetId) {
      context.read<AssetSendFormCubit>().changeFormValue(
            assetId: int.parse(widget.assetId!),
            networkId: int.parse(widget.networkId!),
          );
    }

    return BlocListener<AssetSendFormCubit, AssetSendFormState>(
      listenWhen: (prev, curr) =>
          prev.assetId != curr.assetId || prev.networkId != curr.networkId,
      listener: (context, state) {
        assetWallet = widget.getAssetWallet(context, state.assetId.toString());
        networkWallet = widget.getNetwork(
            context, state.assetId.toString(), state.networkId.toString());
      },
      child: Container(
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
                addressHighlightController.deselect();
                amountHighlightController.deselect();
                assetHighlightController.deselect();
                panelController.close();
              });
              FocusManager.instance.primaryFocus?.unfocus();
              scrollTo(addressKey, 50);
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
                            context.locale.asset_send_screen_send_coins_btn,
                        secondPart:
                            context.locale.asset_exchange_screen_coin_label_lc,
                        actionType: ActionType.close,
                        onBackTap: () => GoRouter.of(context).pop(),
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
                            BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
                              buildWhen: (prev, curr) =>
                                  prev.assetId != curr.assetId,
                              builder: (context, state) => AssetFormAssetItem<
                                  AssetSendFormCubit, AssetSendFormState>(
                                highlighted:
                                    assetHighlightController.highlighted,
                                label: context.locale
                                    .asset_send_screen_what_you_send_label,
                                onTap: () {
                                  GoRouter.of(context).pushNamed(
                                      AuthenticatedRouter.assetSendSearch,
                                      params: {
                                        'assetId': widget.assetId!,
                                        'networkId': widget.networkId!,
                                      });
                                },
                              ),
                            ),
                            Gaps.gap8,
                          ]),
                      HighlightedFormElement(
                          key: addressKey,
                          controller: addressHighlightController,
                          clickableHeight: 120,
                          onTap: () => setState(() {
                                addressHighlightController.deselectConcurrent();
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                          children: [
                            _AddressField(
                              addressController: addressController,
                              highlightController: addressHighlightController,
                              scrollController: scrollController,
                              highlighted:
                                  addressHighlightController.highlighted,
                              qrCodeIconPressed: () =>
                                  setState(() => displayQrCode = true),
                              onTap: () {
                                setState(() {
                                  panelController.close();
                                  _isPanelOpen = false;
                                  addressHighlightController
                                      .deselectConcurrent();

                                  addressController.text = '';
                                });

                                scrollTo(addressKey, 50);
                              },
                            ),
                            Gaps.gap20,
                          ]),
                      HighlightedFormElement(
                          key: amountKey,
                          controller: amountHighlightController,
                          clickableHeight: 90,
                          onTap: () => setState(() {
                                amountHighlightController.deselectConcurrent();
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                          children: [
                            BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
                              buildWhen: (prev, curr) =>
                                  prev.assetId != curr.assetId,
                              builder: (context, state) => _AmountFormField(
                                amountFromController: amountController,
                                highlightController: amountHighlightController,
                                networkWallet: networkWallet!,
                                scrollController: scrollController,
                                onTap: () {
                                  setState(() {
                                    panelController.open();
                                    _isPanelOpen = true;

                                    amountController.text = '';
                                  });

                                  scrollTo(amountKey, 0);
                                },
                                assetId: state.assetId,
                              ),
                            ),
                            Gaps.gap10,
                          ]),
                      if (displayQrCode)
                        QrCodeScanner(
                          errorCallback: () => {
                            // todo: add error message to the user
                          },
                          qrCodeCallback: (String value) =>
                              assetSendCubit.changeFormValue(toAddress: value),
                          closedCallback: () =>
                              setState(() => displayQrCode = false),
                        ),
                      if (amountHighlightController.highlighted)
                        Container(
                          padding: Paddings.left16,
                          child: const AssetFormException<AssetSendFormCubit,
                              AssetSendFormState>(
                            formElementIndex: 0,
                          ),
                        ),
                      if (_isPanelOpen)
                        const SizedBox(
                            height: Constants.panelKeyboardHeightWithButton),
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
                BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
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
      final cubit = context.read<AssetSendFormCubit>();

      return cubit.state.amountUnit == AmountUnit.crypto
          ? cubit.changeFormValue(nextAmountDigit: number.toString())
          : cubit.changeFormValue(nextAmountFiatDigit: number.toString());
    };
  }

  VoidCallback _onErase(BuildContext context) {
    final cubit = context.read<AssetSendFormCubit>();

    return cubit.state.amountUnit == AmountUnit.crypto
        ? cubit.eraseAmount
        : cubit.eraseAmountFiat;
  }

  VoidCallback _onDecimalDotTap(BuildContext context) {
    final cubit = context.read<AssetSendFormCubit>();

    return cubit.state.amountUnit == AmountUnit.crypto
        ? cubit.addDecimalDot
        : cubit.addDecimalDotFiat;
  }
}

class _AddressField extends StatelessWidget {
  final TextEditingController addressController;
  final HighlightController highlightController;
  final ScrollController scrollController;
  final GestureTapCallback onTap;
  final bool highlighted;
  final VoidCallback qrCodeIconPressed;

  const _AddressField({
    required this.addressController,
    required this.scrollController,
    required this.onTap,
    required this.highlighted,
    required this.qrCodeIconPressed,
    required this.highlightController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.top5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.asset_send_screen_send_to_label,
            style: SioTextStyles.bodyL.apply(
              color: highlighted
                  ? Theme.of(context).colorScheme.inverseSurface
                  : Theme.of(context).colorScheme.shadow,
            ),
          ),
          Gaps.gap5,
          BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
            buildWhen: (prev, curr) => prev.toAddress != curr.toAddress,
            builder: (context, state) {
              addressController.text = state.toAddress;
              final assetFormCubit = context.read<AssetSendFormCubit>();

              return HighlightedTextFormField(
                controller: addressController,
                highlighted: highlightController.highlighted,
                onTap: onTap,
                onChanged: (toAddress) =>
                    assetFormCubit.changeFormValue(toAddress: toAddress),
                suffixIconMaxWidth: 280,
                maxLines: addressController.text.length > 20 ? 2 : 1,
                suffixIcon: addressController.value.text.isEmpty
                    ? Container(
                        padding: Paddings.bottom5,
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.copy_outlined,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 24,
                              ),
                              onPressed: () async {
                                ClipboardData? copiedAddress =
                                    await Clipboard.getData(
                                        Clipboard.kTextPlain);

                                assetFormCubit.changeFormValue(
                                    toAddress: copiedAddress?.text ?? '');
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.qr_code_scanner,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 24,
                              ),
                              onPressed: qrCodeIconPressed,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: Paddings.bottom5,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 24,
                          ),
                          onPressed: () {
                            assetFormCubit.changeFormValue(toAddress: '');
                          },
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

class _AmountFormField extends StatelessWidget {
  final TextEditingController amountFromController;
  final HighlightController highlightController;
  final ScrollController scrollController;
  final GestureTapCallback onTap;
  final int assetId;
  final NetworkWallet networkWallet;

  const _AmountFormField({
    required this.amountFromController,
    required this.scrollController,
    required this.onTap,
    required this.assetId,
    required this.highlightController,
    required this.networkWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.top5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
            buildWhen: (prev, curr) =>
                prev.amount != curr.amount ||
                prev.amountFiat != curr.amountFiat ||
                prev.amountUnit != curr.amountUnit,
            builder: (context, state) {
              amountFromController.text = state.amountUnit == AmountUnit.crypto
                  ? ThousandsSeparatorInputFormatter().format(state.amount)
                  : ThousandsSeparatorInputFormatter().format(state.amountFiat);
              final assetFormCubit = context.read<AssetSendFormCubit>();

              return HighlightedNumFormField(
                controller: amountFromController,
                highlighted: highlightController.highlighted,
                onTap: onTap,
                suffixIconMaxWidth: 140,
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
              buttonType: ButtonType.max,
              onTap: () => context
                  .read<AssetSendFormCubit>()
                  .maxAmountClicked(networkWallet),
            ),
          ]),
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
      child: BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
        buildWhen: (prev, curr) => prev.isValid != curr.isValid,
        builder: (context, state) => GradientTextButton(
          context.locale.asset_send_screen_summary_btn_label,
          enabled: state.isValid,
          onPressed: () {
            context.read<AssetSendFormCubit>().changeFormValue(
                  totalAmount: state.totalAmount,
                );

            GoRouter.of(context).pop();
            GoRouter.of(context).pushNamed(
              AuthenticatedRouter.assetSendSummary,
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
