import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/static_progress_stepper.dart';
import 'package:simplio_app/view/widgets/success_check_icon.dart';
import 'package:simplio_app/view/widgets/success_page.dart';

class AssetBuySuccessScreen extends StatelessWidget {
  const AssetBuySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessPage(
      centerChild: Column(
        children: [
          const SuccessCheckIcon(),
          Gaps.gap20,
          Text(
            context.locale.asset_send_success_screen_transaction_success,
            textAlign: TextAlign.center,
            style: SioTextStyles.h1.apply(
              color: SioColors.softBlack,
            ),
          ),
          Gaps.gap32,
          const StaticProgressStepper(
            progressBarType: ProgressBarType.buying,
          )
        ],
      ),
      successAction: () {
        final state = context.read<AssetBuyFormCubit>().state;
        GoRouter.of(context).pop();
        GoRouter.of(context)
            .replaceNamed(AuthenticatedRouter.assetDetail, params: {
          'assetId': state.sourceAssetWallet.assetId.toString(),
          'networkId': state.sourceNetworkWallet.networkId.toString(),
        });
      },
      option: Text(
        context.locale.asset_send_success_screen_transaction_success_option,
        style: SioTextStyles.bodyPrimary.copyWith(
          color: SioColors.softBlack,
        ),
      ),
      optionalAction: () {
        debugPrint('navigate to transaction detail');
        // todo: navigate to transaction detail
      },
    );
  }
}
