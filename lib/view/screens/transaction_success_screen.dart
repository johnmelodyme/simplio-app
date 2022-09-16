import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/success_page.dart';

// todo: add correct colors from pallet when design is finished
class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessPage(
      centerChild: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.radio_button_off_outlined, size: 36),
              const Icon(Icons.radio_button_off_sharp, size: 58),
              Icon(
                Icons.check,
                size: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
          Text(
            context.locale.asset_send_success_screen_transaction_success,
            textAlign: TextAlign.center,
            style: SioTextStyles.headingStyle.apply(
              color: Theme.of(context).colorScheme.background,
            ),
            // todo: add progress bar / stepper when the widget is finished
          ),
        ],
      ),
      doneAction: () => GoRouter.of(context).pop(),
      option: Text(
        context.locale.asset_send_success_screen_transaction_success_option,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      optionalAction: () {
        debugPrint('navigate to transaction detail');
        // todo: navigate to transaction detail
      },
    );
  }
}
