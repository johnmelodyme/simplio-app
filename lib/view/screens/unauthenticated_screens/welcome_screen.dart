import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/sign_in_route.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/sign_up_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/story.dart';
import 'package:simplio_app/view/widgets/welcome_screen_page.dart';
import 'package:sio_glyphs/sio_icons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned.fill(
            child: Story(
              repeat: !const bool.fromEnvironment('TEST_RUN'),
              itemDuration: const Duration(seconds: 3),
              items: [
                WelcomeScreenPage(
                  textSpans: [
                    TextSpan(
                      text: '${context.locale.welcome_screen_page1_discover}\n',
                      style: SioTextStyles.h1.apply(
                        color: SioColorsDark.whiteBlue,
                      ),
                    ),
                    TextSpan(
                      text: '${context.locale.welcome_screen_page1_gamefi} ',
                      style: SioTextStyles.h1
                          .apply(color: SioColorsDark.mentolGreen),
                    ),
                    TextSpan(
                      text: context.locale.welcome_screen_page1_world,
                      style: SioTextStyles.h1
                          .apply(color: SioColorsDark.whiteBlue),
                    ),
                  ],
                  subtitle: context.locale.welcome_screen_page1_subtitle,
                  imageRes: 'assets/images/start_screen1.png',
                ),
                WelcomeScreenPage(
                  textSpans: [
                    TextSpan(
                      text:
                          '${context.locale.welcome_screen_page2_buy_favourite}\n',
                      style: SioTextStyles.h1.apply(
                        color: SioColorsDark.whiteBlue,
                      ),
                    ),
                    TextSpan(
                      text: context.locale.welcome_screen_page2_tokens_and_nfts,
                      style: SioTextStyles.h1
                          .apply(color: SioColorsDark.mentolGreen),
                    ),
                  ],
                  subtitle: context.locale.welcome_screen_page2_subtitle,
                  imageRes: 'assets/images/start_screen2.png',
                ),
                WelcomeScreenPage(
                  textSpans: [
                    TextSpan(
                      text: '${context.locale.welcome_screen_page3_connect} ',
                      style: SioTextStyles.h1.apply(
                        color: SioColorsDark.mentolGreen,
                      ),
                    ),
                    TextSpan(
                      text: context.locale.welcome_screen_page3_to_web3_games,
                      style: SioTextStyles.h1
                          .apply(color: SioColorsDark.whiteBlue),
                    ),
                  ],
                  subtitle: context.locale.welcome_screen_page3_subtitle,
                  imageRes: 'assets/images/start_screen3.png',
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Row(
                children: [
                  const Spacer(
                    flex: 3,
                  ),
                  Expanded(
                    flex: 6,
                    child: Image.asset(
                      'assets/images/simpliona_login.png',
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: Paddings.horizontal20,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: HighlightedElevatedButton.primary(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          SignUpRoute.name,
                        );
                      },
                      label: context.locale.welcome_screen_create_account_btn,
                    ),
                  ),
                  Padding(
                    padding: Paddings.all20,
                    child: GestureDetector(
                      child: Row(
                        key: const Key('welcome-screen-log-in-button'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context
                                .locale.welcome_screen_already_have_an_account,
                            style: SioTextStyles.bodyPrimary.copyWith(
                                color: SioColorsDark.secondary7, height: 1),
                          ),
                          Gaps.gap8,
                          Text(
                            context.locale.welcome_screen_sign_in,
                            style: SioTextStyles.bodyPrimary.copyWith(
                              color: SioColorsDark.mentolGreen,
                              height: 1,
                            ),
                          ),
                          const Icon(
                            SioIcons.arrow_right,
                            size: 14,
                            color: SioColorsDark.mentolGreen,
                          ),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          SignInRoute.name,
                        );
                      },
                    ),
                  ),
                  Gaps.gap10,
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
