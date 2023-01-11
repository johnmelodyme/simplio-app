import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/helpers/big_decimal.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/logic/bloc/asset_swap_form/asset_swap_form_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/mixins/route_builder_mixin.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_swap_summary_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_selection_screen.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_swap_route_selection_screen.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_wallet_expansion_list.dart';
import 'package:simplio_app/view/widgets/asset_wallet_form_item.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/button/pill_button.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/form/selectable_form_section.dart';
import 'package:simplio_app/view/widgets/form/value_form_field.dart';
import 'package:simplio_app/view/widgets/form/value_switch.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/widgets/text/validation_text.dart';

const _selectSourceRoute = 'selectSource';
const _selectTargetRoute = 'selectTarget';

class AssetSwapFormScreen extends StatelessWidget with RouteBuilderMixin {
  const AssetSwapFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case _selectSourceRoute:
            return routeBuilder(
              builder: (context) => AssetSelectionScreen(
                arguments: settings.arguments as AssetSelectionScreenArguments,
              ),
            );
          case _selectTargetRoute:
            return routeBuilder(
              builder: (context) => AssetSwapRouteSelectionScreen(
                arguments: settings.arguments
                    as AssetSwapRouteSelectionScreenArguments,
              ),
            );
        }

        return routeBuilder(
          builder: (context) => const _AssetSwapPage(),
        );
      },
    );
  }
}

class _AssetSwapPage extends StatelessWidget {
  const _AssetSwapPage();

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
        child: BlocBuilder<AssetSwapFormBloc, AssetSwapFormState>(
          buildWhen: (previous, current) {
            return previous is SwapFormInitial || current is SwapFormInitial;
          },
          builder: (context, state) {
            if (state is! SwapRoutesLoaded) {
              return Column(
                children: [
                  const ColorizedAppBar(
                    title: 'Exchange ^coin',
                  ),
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: Dimensions.padding2,
                        color: SioColors.secondary4,
                        backgroundColor: SioColors.secondary2,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is SwapRoutesLoadedFailure) {
              if (state.routes.isEmpty) {
                return _AssetSwapNoRoutes(
                  assetId: state.assetId,
                  networkId: state.networkId,
                );
              }

              // TODO - unknown error
              return Column(
                children: const [
                  ColorizedAppBar(
                    title: 'Exchange ^coin',
                  ),
                  Expanded(
                    child: Center(
                      child: Text('There are not routes available'),
                    ),
                  ),
                ],
              );
            }

            return Column(
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
                            title: 'Exchange ^coin',
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Gaps.gap2,
                            BlocBuilder<AssetSwapFormBloc, AssetSwapFormState>(
                              builder: (context, state) {
                                return state is SwapRoutesLoaded
                                    ? _AssetSwapForm(state: state)
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
                    context.read<AssetSwapFormBloc>().add(ValueUpdated(value));
                  },
                  onTap: (value) {
                    context.read<AssetSwapFormBloc>().add(ValueUpdated(value));
                  },
                  // TODO - Check if safe area cannot be in another place
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: true,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BlocBuilder<AssetSwapFormBloc, AssetSwapFormState>(
                        builder: (context, state) {
                          final s = state;
                          // TODO - add validation.
                          if (s is SwapConverted &&
                              s.response is SwapConvertSuccessResponse) {
                            return HighlightedElevatedButton.primary(
                              label: context.locale.common_continue,
                              onPressed: () {
                                GoRouter.of(context).pushNamed(
                                  AssetSwapSummaryRoute.name,
                                  extra: s,
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
            );
          },
        ),
      ),
    );
  }
}

class _AssetSwapNoRoutes extends StatelessWidget {
  final AssetId assetId;
  final NetworkId networkId;

  const _AssetSwapNoRoutes({
    required this.assetId,
    required this.networkId,
  });

  String firstLetterUppercase(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final detail = Assets.getAssetDetail(assetId);
    final name = detail.name;
    final color = detail.style.primaryColor;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: FixedHeightItemDelegate(
            fixedHeight:
                Constants.appBarHeight + MediaQuery.of(context).viewPadding.top,
            child: const ColorizedAppBar(
              title: 'Exchange ^coin',
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Gaps.gap2,
              Padding(
                padding: Paddings.all20,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: firstLetterUppercase(name),
                        style: SioTextStyles.h2.copyWith(
                          color: color,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' has no available routes at the moment. Please select another coin:',
                        style: SioTextStyles.h2.copyWith(
                          color: SioColors.whiteBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              BlocBuilder<AccountWalletCubit, AccountWalletState>(
                builder: (context, state) {
                  final s = state;

                  return AssetWalletExpansionList.fromAssetWallets(
                    wallets: s is AccountWalletProvided
                        ? s.wallet.enabled
                        : const [],
                    onTap: (value) {
                      if (value.length < 2) return;

                      context.read<AssetSwapFormBloc>().add(
                            RoutesLoaded(
                              assetId: value.first,
                              networkId: value.last,
                            ),
                          );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AssetSwapForm extends StatelessWidget {
  final SwapRoutesLoaded state;

  const _AssetSwapForm({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final s = state;

    Widget sourceItem(AssetId a, NetworkId n) => AssetWalletFormItem(
          assetId: a,
          networkId: n,
          onTap: (assetId, networkId) {
            Navigator.of(context).pushNamed(
              _selectSourceRoute,
              arguments: AssetSelectionScreenArguments(
                assetId: assetId,
                networkId: networkId,
                onSelect: (assetId, networkId) {
                  context.read<AssetSwapFormBloc>().add(
                        RoutesLoaded(
                          assetId: assetId,
                          networkId: networkId,
                        ),
                      );
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );

    Widget targetItem(AssetId a, NetworkId n) => AssetWalletFormItem(
          assetId: a,
          networkId: n,
          onTap: (assetId, networkId) {
            Navigator.of(context).pushNamed(
              _selectTargetRoute,
              arguments: AssetSwapRouteSelectionScreenArguments(
                routes: state.routes,
                onSelect: (route, routes) {
                  context.read<AssetSwapFormBloc>().add(
                        RouteUpdated(
                          target: route,
                          routes: routes,
                        ),
                      );
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );

    if (s is SwapSourceConverting) {
      return Column(
        children: [
          _ConvertedSourceValue(
            key: const ValueKey('swap-source'),
            direction: s.direction,
            source: s.source,
            child: sourceItem(
              s.source.asset.assetId,
              s.source.asset.networkId,
            ),
          ),
          SelectableFormSection(
            label: context.locale.asset_swap_screen_exchange_to,
            children: [
              sourceItem(
                s.target.assetId,
                s.target.networkId,
              ),
              ValueFormField(
                label: context.locale.common_converting_with_dots,
                textStyle: SioTextStyles.bodyS.copyWith(
                  color: SioColors.secondary7,
                ),
                value: '',
                onTap: () {
                  context.read<AssetSwapFormBloc>().add(const ValueSelected(
                        direction: SwapDirection.source,
                      ));
                },
                child: ValueSwitch(
                  value: SwapCurrencyType.crypto,
                  options: [
                    ValueSwitchOption(
                      value: SwapCurrencyType.crypto,
                      label: Assets.getAssetDetail(
                        s.target.assetId,
                      ).ticker,
                      isDisabled: true,
                    ),
                  ],
                ),
              ),
              Gaps.gap16,
            ],
          ),
        ],
      );
    }

    if (s is SwapTargetConverting) {
      return Column(
        children: [
          SelectableFormSection(
            label: context.locale.asset_swap_screen_exchange_from,
            isSelected: s.direction == SwapDirection.source,
            children: [
              sourceItem(
                s.source.assetId,
                s.source.networkId,
              ),
              ValueFormField(
                label: context.locale.common_converting_with_dots,
                textStyle: SioTextStyles.bodyS.copyWith(
                  color: SioColors.secondary7,
                ),
                value: '',
                onTap: () {
                  context.read<AssetSwapFormBloc>().add(const ValueSelected(
                        direction: SwapDirection.source,
                      ));
                },
                child: ValueSwitch(
                  value: SwapCurrencyType.crypto,
                  options: [
                    ValueSwitchOption(
                      value: SwapCurrencyType.crypto,
                      label: Assets.getAssetDetail(
                        s.source.assetId,
                      ).ticker,
                      isDisabled: true,
                    ),
                  ],
                ),
              ),
              Gaps.gap16,
            ],
          ),
          _ConvertedTargetValue(
            key: const ValueKey('swap-target'),
            direction: s.direction,
            target: s.target,
            child: targetItem(
              s.target.asset.assetId,
              s.target.asset.networkId,
            ),
          ),
        ],
      );
    }

    if (s is SwapConverted) {
      return Column(
        children: [
          _ConvertedSourceValue(
            key: const ValueKey('swap-source'),
            direction: s.direction,
            source: s.source,
            response: s.response,
            child: sourceItem(
              s.source.asset.assetId,
              s.source.asset.networkId,
            ),
          ),
          _ConvertedTargetValue(
            key: const ValueKey('swap-target'),
            direction: s.direction,
            target: s.target,
            response: s.response,
            child: targetItem(
              s.target.asset.assetId,
              s.target.asset.networkId,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _ConvertedSourceValue extends StatelessWidget {
  final SwapDirection direction;
  final SwapValue source;
  final Widget? child;
  final SwapConvertResponse? response;

  const _ConvertedSourceValue({
    super.key,
    required this.direction,
    required this.source,
    this.response,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = direction == SwapDirection.source;
    final res = (response is SwapConvertFailureResponse ? response : null)
        as SwapConvertFailureResponse?;

    return SelectableFormSection(
      label: context.locale.asset_swap_screen_exchange_from,
      isSelected: isSelected,
      children: [
        if (child != null) child!,
        ValueFormField(
          label: '0',
          value: source.currencyType == SwapCurrencyType.crypto
              ? source.cryptoAmount.format()
              : source.fiatAmount.format(),
          isFocused: isSelected,
          onTap: () {
            context.read<AssetSwapFormBloc>().add(const ValueSelected(
                  direction: SwapDirection.source,
                ));
          },
          child: isSelected
              ? ValueSwitch<SwapCurrencyType>(
                  value: source.currencyType,
                  options: [
                    ValueSwitchOption(
                      value: SwapCurrencyType.crypto,
                      label: Assets.getAssetDetail(
                        source.asset.assetId,
                      ).ticker,
                    ),
                    const ValueSwitchOption(
                      value: SwapCurrencyType.fiat,
                      label: 'USD',
                    ),
                  ],
                  onSwitch: (value) {
                    context.read<AssetSwapFormBloc>().add(ValueSwitched(
                          direction: SwapDirection.source,
                          currencyType: value,
                        ));
                  },
                )
              : ValueSwitch(
                  value: source.currencyType,
                  options: [
                    ValueSwitchOption(
                      value: SwapCurrencyType.crypto,
                      label: Assets.getAssetDetail(
                        source.asset.assetId,
                      ).ticker,
                      isDisabled: true,
                    ),
                  ],
                ),
        ),
        isSelected
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.padding8),
                    child: Row(
                      children: [
                        PillButton(
                          context.locale.common_min_label_uc,
                          onTap: () {
                            context.read<AssetSwapFormBloc>().add(
                                  const MinValueRequested(),
                                );
                          },
                        ),
                        Gaps.gap4,
                        PillButton(
                          context.locale.common_max_label_uc,
                          onTap: () {
                            // TODO - add a available asset wallet
                            final s = context.read<AccountWalletCubit>().state;
                            if (s is! AccountWalletProvided) return;

                            final networkWallet = s.wallet
                                .getWallet(source.asset.assetId)
                                ?.getWallet(source.asset.networkId);
                            if (networkWallet == null) return;

                            context.read<AssetSwapFormBloc>().add(
                                  MaxValueRequested(
                                    balance: BigDecimal.fromBigInt(
                                      networkWallet.balance,
                                    ),
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (res != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: Dimensions.padding16,
                      ),
                      child: ValidationText(
                        res.error.message,
                        type: ValidationTextType.error,
                      ),
                    ),
                ],
              )
            : Gaps.gap16,
      ],
    );
  }
}

class _ConvertedTargetValue extends StatelessWidget {
  final SwapDirection direction;
  final SwapValue target;
  final SwapConvertResponse? response;
  final Widget? child;

  const _ConvertedTargetValue({
    super.key,
    required this.direction,
    required this.target,
    this.response,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = direction == SwapDirection.target;
    final res = (response is SwapConvertFailureResponse ? response : null)
        as SwapConvertFailureResponse?;

    return SelectableFormSection(
      key: const ValueKey('swap-source'),
      label: context.locale.asset_swap_screen_exchange_to,
      isSelected: isSelected,
      children: [
        if (child != null) child!,
        ValueFormField(
          label: '0',
          value: target.currencyType == SwapCurrencyType.crypto
              ? target.cryptoAmount.format()
              : target.fiatAmount.format(),
          isFocused: isSelected,
          onTap: () {
            context.read<AssetSwapFormBloc>().add(const ValueSelected(
                  direction: SwapDirection.target,
                ));
          },
          child: isSelected
              ? ValueSwitch<SwapCurrencyType>(
                  value: target.currencyType,
                  options: [
                    ValueSwitchOption(
                      value: SwapCurrencyType.crypto,
                      label: Assets.getAssetDetail(
                        target.asset.assetId,
                      ).ticker,
                    ),
                    const ValueSwitchOption(
                      value: SwapCurrencyType.fiat,
                      label: 'USD',
                    ),
                  ],
                  onSwitch: (value) {
                    context.read<AssetSwapFormBloc>().add(ValueSwitched(
                          direction: SwapDirection.source,
                          currencyType: value,
                        ));
                  },
                )
              : ValueSwitch(
                  value: target.currencyType,
                  options: [
                    ValueSwitchOption(
                      value: SwapCurrencyType.crypto,
                      label: Assets.getAssetDetail(
                        target.asset.assetId,
                      ).ticker,
                      isDisabled: true,
                    ),
                  ],
                ),
        ),
        isSelected && res != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.padding16,
                ),
                child: ValidationText(
                  res.error.message,
                  type: ValidationTextType.error,
                ),
              )
            : Gaps.gap16,
      ],
    );
  }
}
