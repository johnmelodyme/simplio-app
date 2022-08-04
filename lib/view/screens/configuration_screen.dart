import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                var currentLanguage = context.locale.localeName;
                var newLanguage = context.supportedLanguageCodes
                    .firstWhere((element) => element != currentLanguage);

                context
                    .read<AccountCubit>()
                    .setLanguage(newLanguage)
                    .then((value) {
                  var newTheme = context
                      .read<AccountCubit>()
                      .state
                      .account
                      ?.settings
                      .themeMode;

                  context.read<AccountCubit>().setTheme(
                      newTheme == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark);
                });
              },
              child: Text(context.locale.switchLanguage),
            ),
            ElevatedButton(
              child: const Text('Change password'),
              onPressed: () {
                GoRouter.of(context)
                    .pushNamed(AuthenticatedRouter.passwordChange);
              },
            ),
            ElevatedButton(
              child: const Text('Sign out'),
              onPressed: () {
                context.read<AuthBloc>().add(const GotUnauthenticated());
              },
            ),
          ],
        ),
      ),
    );
  }
}
