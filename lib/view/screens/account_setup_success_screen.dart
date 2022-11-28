import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
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
        child: BackGradient4(
          child: Column(
            children: [
              const ColorizedAppBar(
                key: Key('account_setup_success-screen-app-bar'),
                firstPart: '',
                secondPart: '',
                actionType: ActionType.close,
              ),
              Expanded(
                child: Padding(
                  padding: Paddings.horizontal16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 6,
                                child: Image.asset(
                                  'assets/images/blue_ring.png',
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 4,
                                child: Image.asset(
                                  'assets/images/simpliona_login.png',
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${context.locale.account_setup_success_screen_account_created_title1} ',
                              style: SioTextStyles.h1.apply(
                                color: SioColorsDark.mentolGreen,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${context.locale.account_setup_success_screen_account_created_title2} ',
                              style: SioTextStyles.h1
                                  .apply(color: SioColorsDark.whiteBlue),
                            ),
                          ],
                        ),
                      ),
                      Gaps.gap10,
                      Text(
                        context.locale
                            .account_setup_success_screen_account_created_description_label,
                        textAlign: TextAlign.center,
                        style: SioTextStyles.bodyPrimary.apply(
                          color: SioColorsDark.secondary7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: Paddings.horizontal16,
                child: SizedBox(
                  width: double.infinity,
                  child: HighlightedElevatedButton(
                    onPressed: () {
                      GoRouter.of(context)
                          .goNamed(AuthenticatedRouter.discovery);
                    },
                    label: context.locale.common_continue,
                  ),
                ),
              ),
              Gaps.gap30,
            ],
          ),
        ),
      )),
    );
  }
}
