import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/headline_text.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class AccountSetupSuccessScreen extends StatelessWidget {
  const AccountSetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      key: const ValueKey('account-setup-success-screen'),
      onWillPop: () async => false,
      child: SioScaffold(
          body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: Paddings.all20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadlineText(context.locale
                        .account_setup_success_screen_account_created_label),
                    Padding(
                      padding: Paddings.vertical20,
                      child: Text(context.locale
                          .account_setup_success_screen_account_created_description_label),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context)
                          .goNamed(AuthenticatedRouter.discovery);
                    },
                    child: Text(context.locale
                        .account_setup_success_screen_account_created_start_button),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(context.locale
                        .account_setup_success_screen_account_created_verify_button),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
