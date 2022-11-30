import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/inventory_screen.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/static_progress_stepper.dart';
import 'package:simplio_app/view/widgets/success_check_icon.dart';
import 'package:simplio_app/view/widgets/success_page.dart';

class AssetExchangeSuccessScreen extends StatelessWidget {
  const AssetExchangeSuccessScreen({super.key});

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
            progressBarType: ProgressBarType.exchanging,
          )
        ],
      ),
      successAction: () {
        GoRouter.of(context).goNamed(
          AuthenticatedRouter.inventory,
          extra: InventoryTab.transactions,
        );
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
