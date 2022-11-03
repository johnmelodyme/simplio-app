import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/confirmation_warning_icon.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/success_page.dart';

class AssetBuyConfirmationScreen extends StatelessWidget with WalletUtilsMixin {
  const AssetBuyConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetBuyFormCubit, AssetBuyFormState>(
      listener: (context, state) {
        if (state.response is AssetBuyFormPending) {
          GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetBuyPaymentGateway,
              params: {
                'assetId': state.sourceAssetWallet.assetId.toString(),
                'networkId': state.sourceNetworkWallet.networkId.toString(),
              });
        }
      },
      buildWhen: (prev, curr) => prev.response != curr.response,
      builder: (context, state) => state.response
              is AssetBuyFormPriceRefreshPending
          ? SuccessPage(
              hasSuccessButton: false,
              centerChild: Column(
                children: const [
                  ListLoading(
                    activeColor: SioColorsDark.secondary2,
                    backgroundColor: SioColorsDark.whiteBlue,
                  ),
                ],
              ),
              successAction: () => {})
          : SuccessPage(
              goBack: true,
              goBackAction: () {
                GoRouter.of(context).replaceNamed(
                  AuthenticatedRouter.assetBuySummary,
                  params: {
                    'assetId': state.sourceAssetWallet.assetId.toString(),
                    'networkId': state.sourceNetworkWallet.networkId.toString(),
                  },
                );
              },
              successAction: () {
                final address = getAddress(
                        context,
                        state.sourceAssetWallet.assetId.toString(),
                        state.sourceNetworkWallet.networkId.toString()) ??
                    '';
                context
                    .read<AssetBuyFormCubit>()
                    .submitForm(walletAddress: address);
              },
              successLabel:
                  context.locale.asset_buy_confirmation_screen_accept_new_price,
              centerChild: Column(
                children: [
                  const ConfirmationWarningIcon(),
                  Gaps.gap20,
                  Text(
                    context.locale.asset_buy_confirmation_screen_price_update,
                    textAlign: TextAlign.center,
                    style: SioTextStyles.h1.apply(
                      color: SioColors.softBlack,
                    ),
                  ),
                  Text(
                    context
                        .locale.asset_buy_confirmation_screen_price_has_changed,
                    textAlign: TextAlign.center,
                    style: SioTextStyles.bodyPrimary.apply(
                      color: SioColors.softBlack,
                    ),
                  ),
                  Gaps.gap20,
                  Padding(
                    padding: Paddings.horizontal16,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.padding17,
                        horizontal: Dimensions.padding20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadii.radius20,
                        color: SioColors.whiteBlue,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.locale
                                .asset_buy_summary_screen_in_total_to_buy,
                            style: SioTextStyles.bodyPrimary.copyWith(
                              color: SioColors.secondary6,
                            ),
                          ),
                          Gaps.gap16,
                          Row(
                            children: [
                              Text(
                                '${state.buyConvertResponse.cryptoAsset.amount} ${Assets.getNetworkDetail(state.sourceNetworkWallet.networkId).ticker}',
                                style: SioTextStyles.bodyPrimary.copyWith(
                                  color: SioColors.softBlack,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  state.buyConvertResponse.fiatAsset.amount
                                      .getThousandValueWithCurrency(
                                    currency: state
                                        .buyConvertResponse.fiatAsset.assetId,
                                    locale: Intl.getCurrentLocale(),
                                  ),
                                  textAlign: TextAlign.right,
                                  style: SioTextStyles.h4.copyWith(
                                    color: SioColors.softBlack,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
