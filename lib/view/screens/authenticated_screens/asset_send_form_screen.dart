import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/logic/bloc/asset_send_form/asset_send_form_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/errors/validation_error.dart';
import 'package:simplio_app/view/mixins/route_builder_mixin.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_send_summary_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_selection_screen.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_send_qr_scanner_screen.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_wallet_form_item.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/button/gradient_button.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/button/pill_button.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/form/selectable_form_section.dart';
import 'package:simplio_app/view/widgets/form/value_form_field.dart';
import 'package:simplio_app/view/widgets/form/value_switch.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/widgets/text/validation_text.dart';
import 'package:sio_glyphs/sio_icons.dart';

const _selectSource = 'selectSource';
const _scanTarget = 'scanTarget';

class AssetSendFormScreen extends StatelessWidget with RouteBuilderMixin {
  const AssetSendFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case _selectSource:
            return routeBuilder(
              builder: (context) => AssetSelectionScreen(
                arguments: settings.arguments as AssetSelectionScreenArguments,
              ),
            );

          case _scanTarget:
            return routeBuilder(
              builder: (context) => AssetSendQrScannerScreen(
                arguments:
                    settings.arguments as AssetSendQrScannerScreenArguments,
              ),
            );
        }

        return routeBuilder(
          builder: (context) => const _AssetSendPage(),
        );
      },
    );
  }
}

class _AssetSendPage extends StatelessWidget {
  const _AssetSendPage();

  @override
  Widget build(BuildContext context) {
    final accountWalletState = context.read<AccountWalletCubit>().state;
    if (accountWalletState is! AccountWalletProvided) {
      // TODO - resolve an error where account wallet is not provided;
      // TODO - Get unauhenticated?
      GoRouter.of(context).pop();
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: BackGradient4(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: FixedHeightItemDelegate(
                      fixedHeight: Constants.appBarHeight +
                          MediaQuery.of(context).viewPadding.top,
                      child: const ColorizedAppBar(
                        title: 'Send ^coin',
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Gaps.gap2,
                        BlocBuilder<AssetSendFormBloc, AssetSendFormState>(
                          builder: (context, state) {
                            return state is SendFormConverted
                                ? Column(
                                    children: [
                                      _SourceFormField(
                                        assetId: state.assetId,
                                        networkWallet: state.wallet,
                                        accountWallet:
                                            accountWalletState.wallet,
                                      ),
                                      _AmountFormField(
                                        state: state,
                                        errors: state
                                            .validation.amountValidationErrors,
                                      ),
                                      _TargetFormField(
                                        wallet: state.wallet,
                                        address: state.address,
                                        errors: state
                                            .validation.addressValidationErrors,
                                      ),
                                    ],
                                  )
                                // TODO - this may not be correct.
                                : const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // TODO - It is possible to display keyboard programmatically with `BottomSheet` widget.
            Numpad(
              displayEraseButton: true,
              displayDecimalButton: true,
              onLongPress: (value) {
                context.read<AssetSendFormBloc>().add(ValueUpdated(value));
              },
              onTap: (value) {
                context.read<AssetSendFormBloc>().add(ValueUpdated(value));
              },
              // TODO - Check if safe area cannot be in another place
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                child: Padding(
                  padding: Paddings.all20,
                  child: BlocBuilder<AssetSendFormBloc, AssetSendFormState>(
                    builder: (context, state) {
                      if (state is! SendFormConverted) {
                        return const SizedBox.shrink();
                      }

                      if (state.validation.isValid) {
                        return HighlightedElevatedButton.primary(
                          label: context.locale.common_continue,
                          onPressed: () {
                            GoRouter.of(context).pushNamed(
                              AssetSendSummaryRoute.name,
                            );
                          },
                        );
                      }

                      return HighlightedElevatedButton.disabled(
                        label: context.locale.common_continue,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceFormField extends StatelessWidget {
  final AssetId assetId;
  final NetworkWallet networkWallet;
  final AccountWallet accountWallet;

  const _SourceFormField({
    required this.assetId,
    required this.networkWallet,
    required this.accountWallet,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableFormSection(
      label: context.locale.asset_send_screen_source_label,
      children: [
        AssetWalletFormItem(
          assetId: assetId,
          networkId: networkWallet.networkId,
          onTap: (assetId, networkId) {
            Navigator.of(context).pushNamed(
              _selectSource,
              arguments: AssetSelectionScreenArguments(
                assetId: assetId,
                networkId: networkId,
                onSelect: (assetId, networkId) {
                  final w =
                      accountWallet.getWallet(assetId)?.getWallet(networkId);

                  if (w != null) {
                    context
                        .read<AssetSendFormBloc>()
                        .add(PriceLoaded(assetId: assetId, wallet: w));
                  }
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
        Gaps.gap16,
      ],
    );
  }
}

class _TargetFormField extends StatelessWidget {
  final NetworkWallet wallet;
  final String address;
  final Set<ValidationError> errors;

  const _TargetFormField({
    required this.wallet,
    required this.address,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableFormSection(
      label: context.locale.asset_send_screen_target_label,
      children: [
        address.isNotEmpty
            ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadii.radius20,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SioColors.backGradient3Start.withOpacity(0.5),
                      SioColors.backGradient3End.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.padding16,
                              left: Dimensions.padding16,
                              bottom: Dimensions.padding16,
                            ),
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: SioTextStyles.bodyS.copyWith(
                                color: SioColors.whiteBlue,
                              ),
                            ),
                          ),
                        ),
                        Gaps.gap16,
                        IconButton(
                          icon: const Icon(SioIcons.cancel, size: 20),
                          color: SioColors.secondary6,
                          padding: Paddings.all16,
                          onPressed: () => context
                              .read<AssetSendFormBloc>()
                              .add(AddressUpdated(
                                networkId: wallet.networkId,
                              )),
                        ),
                      ],
                    ),
                    if (errors.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Dimensions.padding16,
                          left: Dimensions.padding16,
                          right: Dimensions.padding16,
                        ),
                        child: ValidationText(
                          errors.first.message,
                          type: ValidationTextType.error,
                        ),
                      ),
                  ],
                ),
              )
            : Row(
                children: [
                  GradientButton(
                    key: const ObjectKey('asset-send-screen-paste-button'),
                    label: 'Paste',
                    icon: SioIcons.copy,
                    onTap: () {
                      Clipboard.getData('text/plain').then((value) {
                        if (value == null) return;
                        HapticFeedback.vibrate();
                        context.read<AssetSendFormBloc>().add(AddressUpdated(
                              address: value.text,
                              networkId: wallet.networkId,
                            ));
                      });
                    },
                  ),
                  Gaps.gap16,
                  GradientButton(
                    key: const ObjectKey('asset-send-screen-scan-button'),
                    label: 'Scan QR',
                    icon: SioIcons.qr_code,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        _scanTarget,
                        arguments: AssetSendQrScannerScreenArguments(
                          networkId: wallet.networkId,
                          onScan: (address) {
                            HapticFeedback.vibrate();

                            context
                                .read<AssetSendFormBloc>()
                                .add(AddressUpdated(
                                  address: address,
                                  networkId: wallet.networkId,
                                ));

                            Navigator.of(context).pop();
                          },
                          onError: (error) => Navigator.of(context).pop(),
                        ),
                      );
                    },
                  ),
                ],
              ),
        Gaps.gap16,
      ],
    );
  }
}

class _AmountFormField extends StatelessWidget {
  final SendFormConverted state;
  final Set<ValidationError> errors;

  const _AmountFormField({
    required this.state,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    // final isSelected = state.section == SendFormFieldSection.amount;
    const isSelected = true;
    final details = Assets.getAssetDetail(state.assetId);

    return SelectableFormSection(
      label: context
          .locale.asset_send_summary_screen_transaction_summary_amount_to_send,
      isSelected: true,
      children: [
        ValueFormField(
          label: '0',
          value: state.currencyType == SendCurrencyType.crypto
              ? state.cryptoAmount.format()
              : state.fiatAmount.format(),
          isFocused: isSelected,
          onTap: () {
            // TODO - selecting the form field.
          },
          child: ValueSwitch<SendCurrencyType>(
            value: state.currencyType,
            options: [
              ValueSwitchOption(
                value: SendCurrencyType.crypto,
                label: details.ticker,
              ),
              const ValueSwitchOption(
                value: SendCurrencyType.fiat,
                label: 'USD',
              ),
            ],
            onSwitch: (value) {
              context
                  .read<AssetSendFormBloc>()
                  .add(ValueSwitched(currencyType: value));
            },
          ),
        ),
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: Dimensions.padding8),
              child: Row(
                children: [
                  PillButton(
                    context.locale.common_max_label_uc,
                    onTap: () {
                      context
                          .read<AssetSendFormBloc>()
                          .add(const MaxValueRequested());
                    },
                  ),
                ],
              ),
            ),
            // if (res != null)
            //   Padding(
            //     padding: const EdgeInsets.only(
            //       bottom: Dimensions.padding16,
            //     ),
            //     child: ValidationText(
            //       res.error.message,
            //       type: ValidationTextType.error,
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }
}
