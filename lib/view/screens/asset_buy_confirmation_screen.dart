import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/confirmation_warning_icon.dart';
import 'package:simplio_app/view/widgets/success_page.dart';

class AssetBuyConfirmationScreen extends StatelessWidget {
  const AssetBuyConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AssetBuyFormCubit>().state;
    final response = state.response;
    if (response is AssetBuyFormPriceRefreshSuccess &&
        response.confirmationNeeded) {
      return BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
        listener: (context, state) {
          if (state.response is AssetBuyFormPending) {
            GoRouter.of(context).replaceNamed(
                AuthenticatedRouter.assetBuyPaymentGateway,
                params: {
                  'assetId': state.assetId.toString(),
                  'networkId': state.networkId.toString(),
                });
          }
        },
        child: SuccessPage(
          goBack: true,
          goBackAction: () {
            GoRouter.of(context).replaceNamed(
              AuthenticatedRouter.assetBuySummary,
              params: {
                'assetId': state.assetId.toString(),
                'networkId': state.networkId.toString(),
              },
            );
          },
          successAction: () {
            context.read<AssetBuyFormCubit>().submitForm(testSubmit: true);
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
                context.locale.asset_buy_confirmation_screen_price_has_changed,
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
                        context.locale.asset_buy_summary_screen_in_total_to_buy,
                        style: SioTextStyles.bodyPrimary.copyWith(
                          color: SioColors.secondary6,
                        ),
                      ),
                      Gaps.gap16,
                      Row(
                        children: [
                          Text(
                            '${response.newTotalAmount} ${Assets.getNetworkDetail(state.networkId).ticker}',
                            style: SioTextStyles.bodyPrimary.copyWith(
                              color: SioColors.softBlack,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              double.parse(response.newTotalAmountFiat!)
                                  .getThousandValueWithCurrency(
                                currency:
                                    'USD', //TODO.. replace by real currency
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
    } else {
      throw Exception(
          'Incorrect state. Response needs to be AssetBuyFormConfirmationNeeded');
    }
  }
}
