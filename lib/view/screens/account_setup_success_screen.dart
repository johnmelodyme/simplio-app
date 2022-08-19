import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/widgets/headline_text.dart';

class AccountSetupSuccessScreen extends StatelessWidget {
  const AccountSetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      key: const ValueKey('account-setup-success-screen'),
      onWillPop: () async => false,
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: CommonTheme.paddingAll,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadlineText(context.locale.accountCreatedLabel),
                    Padding(
                      padding: CommonTheme.verticalPadding,
                      child:
                          Text(context.locale.accountCreatedDescriptionLabel),
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
                    child: Text(context.locale.accountCreatedStartButton),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(context.locale.accountCreatedVerifyButton),
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
