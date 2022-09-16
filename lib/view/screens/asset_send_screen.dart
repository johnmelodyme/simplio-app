import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/body_text.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/qr_code_scanner.dart';
import 'package:simplio_app/view/widgets/secondary_text_form_field.dart';
import 'package:simplio_app/view/widgets/themed_text.dart';
import 'package:simplio_app/view/widgets/toggle.dart';

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

class _AssetSendScreen extends State<AssetSendScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool displayQrCode = false;

  late AssetWallet? assetWallet;
  late NetworkWallet? networkWallet;

  @override
  void initState() {
    super.initState();

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
        );
  }

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    Map<AssetItem, AssetDetail> availableAssets = {
      for (var a in s.wallet.wallets)
        for (var n in a.wallets)
          AssetItem(assetId: a.assetId, networkId: n.networkId):
              Assets.getNetworkDetail(n.networkId)
    };

    final AssetSendFormCubit assetSendCubit =
        context.read<AssetSendFormCubit>();

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: Paddings.all20,
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).pop();
            GoRouter.of(context).pushNamed(
              AuthenticatedRouter.assetSendSummary,
              params: {
                'assetId': widget.assetId!,
                'networkId': widget.networkId!,
              },
              extra: context
                  .read<AssetSendFormCubit>()
                  .state, // need to pass current state
            );
          },
          child: Text(context.locale.asset_send_screen_summary_btn_label),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: Paddings.horizontal20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
                      buildWhen: (prev, curr) => prev.assetId != curr.assetId,
                      builder: (context, state) => ColorizedAppBar(
                        firstPart:
                            context.locale.asset_send_screen_send_coins_btn,
                        secondPart: Assets.getAssetDetail(state.assetId).name,
                        actionType: ActionType.close,
                        onBackTap: () => GoRouter.of(context).pop(),
                      ),
                    ),
                    _WhatToSend(
                      availableAssets: availableAssets,
                      assetId: int.parse(widget.assetId!),
                      networkId: int.parse(widget.networkId!),
                    ),
                    _SendTo(
                      addressController: addressController,
                      qrCodeIconPressed: () =>
                          setState(() => displayQrCode = true),
                    ),
                    _Amount(amountController: amountController),
                  ],
                ),
              ),
              if (displayQrCode)
                QrCodeScanner(
                  errorCallback: () => {
                    // todo: add error message to the user
                  },
                  qrCodeCallback: (String value) =>
                      assetSendCubit.changeFormValue(address: value),
                  closedCallback: () => setState(() => displayQrCode = false),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class AssetItem {
  const AssetItem({
    required this.assetId,
    required this.networkId,
  });

  final int assetId;
  final int networkId;

  @override
  bool operator ==(other) {
    return other is AssetItem &&
        assetId == other.assetId &&
        networkId == other.networkId;
  }

  @override
  int get hashCode => assetId * networkId;
}

class _SendTo extends StatelessWidget {
  final TextEditingController addressController;
  final VoidCallback qrCodeIconPressed;

  const _SendTo({
    required this.addressController,
    required this.qrCodeIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(context.locale.asset_send_screen_send_to_label),
        BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
          buildWhen: (prev, curr) => prev.address != curr.address,
          builder: (context, state) {
            final AssetSendFormCubit assetSendCubit =
                context.read<AssetSendFormCubit>();

            addressController.text = assetSendCubit.state.address;

            return SecondaryTextFormField(
              controller: addressController,
              onChanged: (value) =>
                  assetSendCubit.changeFormValue(address: value),
              suffixIcon: Padding(
                padding: Paddings.right10,
                child: addressController.value.text.isEmpty
                    ? SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy_all),
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () async {
                                ClipboardData? copiedAddress =
                                    await Clipboard.getData(
                                        Clipboard.kTextPlain);

                                assetSendCubit.changeFormValue(
                                    address: copiedAddress?.text ?? '');
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadiuses.radius12,
                                ),
                                child: IconButton(
                                  icon:
                                      const Icon(Icons.qr_code_scanner_rounded),
                                  onPressed: qrCodeIconPressed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.close),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          assetSendCubit.changeFormValue(address: '');
                        },
                      ),
              ),
            );
          },
        ),
        const Gap(Dimensions.padding8)
      ],
    );
  }
}

class _Amount extends StatelessWidget {
  final TextEditingController amountController;
  const _Amount({required this.amountController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.top20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
            buildWhen: (prev, curr) =>
                prev.amount != curr.amount ||
                prev.amountUnit != curr.amountUnit ||
                prev.assetId != curr.assetId,
            builder: (context, state) {
              amountController.text = state.amount;
              var assetFormCubit = context.read<AssetSendFormCubit>();

              return SecondaryTextFormField(
                controller: amountController,
                readOnly: true,
                decoration:
                    const InputDecoration(contentPadding: Paddings.all10),
                suffixIconMaxWidth: 140,
                suffixIcon: Padding(
                  padding: Paddings.left10,
                  child: SizedBox(
                    width: 300,
                    child: Toggle(
                      trueOption: Padding(
                        padding: Paddings.all8,
                        child: ThemedText(
                            Assets.getAssetDetail(state.assetId).ticker),
                      ),
                      falseOption: const Padding(
                        padding: Paddings.all8,
                        child: ThemedText('USD'),
                      ),
                      value: state.amountUnit == AmountUnit.crypto,
                      onChanged: (value) => assetFormCubit.changeAmountUnit(
                          value ? AmountUnit.crypto : AmountUnit.fiat),
                    ),
                  ),
                ),
              );
            },
          ),
          Row(children: [
            TextButton(
                onPressed: () =>
                    context.read<AssetSendFormCubit>().minAmountClicked(),
                child: Text(
                  context.locale.common_min_label_uc,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )),
            TextButton(
                onPressed: () =>
                    context.read<AssetSendFormCubit>().maxAmountClicked(),
                child: Text(
                  context.locale.common_max_label_uc,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )),
          ]),
          BlocBuilder<AssetSendFormCubit, AssetSendFormState>(
              buildWhen: (prev, curr) => prev.amount != curr.amount,
              builder: (context, state) {
                return Visibility(
                  visible: double.parse(state.amount) > 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      const Gap(Dimensions.padding5),
                      Text(
                        context.locale
                            .asset_send_summary_screen_transaction_includes_fees_warning,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Numpad(
            onTap: (number) =>
                context.read<AssetSendFormCubit>().changeFormValue(
                      amount: number.toString(),
                    ),
            isDecimal: true,
            onErase: () => context.read<AssetSendFormCubit>().eraseAmount(),
            onDecimalDotTap: () =>
                context.read<AssetSendFormCubit>().addDecimalDot(),
          ),
        ],
      ),
    );
  }
}

class _WhatToSend extends StatefulWidget {
  final Map<AssetItem, AssetDetail> availableAssets;
  final int assetId;
  final int networkId;

  const _WhatToSend({
    required this.availableAssets,
    required this.assetId,
    required this.networkId,
  });

  @override
  State<StatefulWidget> createState() => _WhatToSendState();
}

class _WhatToSendState extends State<_WhatToSend> {
  late AssetItem? dropdownValue;

  @override
  void initState() {
    super.initState();

    dropdownValue = AssetItem(
      assetId: widget.assetId,
      networkId: widget.networkId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(context.locale.asset_send_screen_what_you_send_label),
        Padding(
          padding: Paddings.bottom20,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiuses.radius12,
                color: Theme.of(context).colorScheme.primaryContainer),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AssetItem>(
                isExpanded: true,
                itemHeight: 60,
                value: dropdownValue,
                icon: const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                onChanged: (AssetItem? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    context.read<AssetSendFormCubit>().changeFormValue(
                          assetId: newValue.assetId,
                          networkId: newValue.networkId,
                        );
                  });
                },
                items: widget.availableAssets.keys.map((e) {
                  AssetDetail assetDetail = Assets.getAssetDetail(e.assetId);
                  AssetDetail networkDetail =
                      Assets.getNetworkDetail(e.networkId);

                  return DropdownMenuItem<AssetItem>(
                    value: AssetItem(
                      assetId: e.assetId,
                      networkId: e.networkId,
                    ),
                    child: Padding(
                      padding: Paddings.vertical10,
                      child: Row(
                        children: [
                          Padding(
                            padding: Paddings.horizontal10,
                            child: Icon(
                              assetDetail.style.icon,
                              color: networkDetail.style.primaryColor,
                              size: 32,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${assetDetail.name} (${assetDetail.ticker})'),
                              Text(
                                context.locale
                                    .asset_receive_screen_crypto_chain(
                                        networkDetail.name),
                              ),
                            ],
                          ),
                          Expanded(
                            child: BlocBuilder<AccountWalletCubit,
                                AccountWalletState>(
                              builder: (context, state) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text('--'),
                                  Text('--'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
