import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/unauthenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/bordered_text_button.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/story.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: SafeArea(
        child: Story(
          repeat: !const bool.fromEnvironment('TEST_RUN'),
          itemDuration: const Duration(seconds: 2),
          items: [
            Container(
              width: double.infinity,
              color: Colors.red,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Placeholder 1',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge?.fontSize),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.green,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Placeholder 2',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge?.fontSize),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.orange,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Placeholder 3',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge?.fontSize),
                ),
              ),
            ),
          ],
          bottomNavigationBar: Padding(
            padding: Paddings.horizontal20,
            child: Column(
              children: [
                Padding(
                  padding: Paddings.bottom20,
                  child: SizedBox(
                    width: double.infinity,
                    child: HighlightedElevatedButton(
                      onPressed: () => {},
                      label: context.locale.welcome_screen_go_to_app_btn,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: BorderedTextButton(
                    onPressed: () {
                      GoRouter.of(context)
                          .pushNamed(UnauthenticatedRouter.signIn);
                    },
                    label: context.locale.common_log_in_button_label,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
