import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/password_change_form/password_change_form_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/routes/guards/protected_guard.dart';
import 'package:simplio_app/view/routes/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/routes/observers/tap_bar_observer.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';
import 'package:simplio_app/view/screens/application_screen.dart';
import 'package:simplio_app/view/screens/configuration_screen.dart';
import 'package:simplio_app/view/screens/dashboard_screen.dart';
import 'package:simplio_app/view/screens/inventory_screen.dart';
import 'package:simplio_app/view/screens/password_change_screen.dart';
import 'package:simplio_app/view/screens/pin_setup_screen.dart';
import 'package:simplio_app/view/screens/portfolio_screen.dart';
import 'package:simplio_app/view/screens/account_setup_success_screen.dart';

class AuthenticatedRouter with PageBuilderMixin {
  static const String dashboard = 'dashboard';
  static const String portfolio = 'portfolio';
  static const String inventory = 'inventory';
  static const String configuration = 'configuration';
  static const String pinSetup = 'pin-setup';
  static const String accountSetup = 'account-setup';
  static const String passwordChange = 'password-change';

  final BuildContext context;

  AuthenticatedRouter.of(this.context);

  GoRouter get router {
    return GoRouter(
      initialLocation: '/in',
      navigatorBuilder: (_, __, child) => ProtectedGuard(
        protectWhen: (account) =>
            account.securityLevel.index > SecurityLevel.none.index &&
            account.secret.unlockedValue == null,
        protectedChild: ApplicationScreen(
          child: child,
        ),
        onPrevent: (context) {
          context.read<AuthBloc>().add(const GotUnauthenticated());
        },
      ),
      observers: [
        TapBarObserver.of(context),
      ],
      routes: [
        GoRoute(
          path: '/in',
          redirect: (state) {
            final account = context.read<AccountCubit>().state.account;

            if (account != null) {
              if (account.securityLevel.index <= SecurityLevel.none.index) {
                return '/set/pin-setup';
              }
            }

            return '/in/dashboard';
          },
          routes: [
            GoRoute(
              path: 'dashboard',
              name: dashboard,
              pageBuilder: pageBuilder(
                child: const DashboardScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tapBar: TapBarRouteSettings(
                    selectedKey: const ValueKey(dashboard),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'portfolio',
              name: portfolio,
              pageBuilder: pageBuilder(
                child: const PortfolioScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tapBar: TapBarRouteSettings(
                    selectedKey: const ValueKey(portfolio),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'inventory',
              name: inventory,
              pageBuilder: pageBuilder(
                child: const InventoryScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tapBar: TapBarRouteSettings(
                    selectedKey: const ValueKey(inventory),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'configuration',
              name: configuration,
              pageBuilder: pageBuilder(
                child: const ConfigurationScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tapBar: TapBarRouteSettings(
                    selectedKey: const ValueKey(configuration),
                  ),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'password-change',
                  name: passwordChange,
                  pageBuilder: pageBuilder(
                    settings: ApplicationSettings(
                      tapBar: TapBarRouteSettings(
                        selectedKey: const ValueKey(configuration),
                        isVisible: false,
                      ),
                    ),
                    child: BlocProvider(
                      create: (context) => PasswordChangeFormCubit.builder(
                        authRepository:
                            RepositoryProvider.of<AuthRepository>(context),
                      ),
                      child: ProtectedGuard(
                        protectedChild: const PasswordChangeScreen(),
                        onPrevent: (context) => context.goNamed(configuration),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/set',
          redirect: (state) => '/set/pin-setup',
          routes: [
            GoRoute(
              path: 'pin-setup',
              name: pinSetup,
              pageBuilder: pageBuilder(
                child: BlocProvider(
                  create: (context) => PinSetupFormCubit.builder(
                    accountRepository:
                        RepositoryProvider.of<AccountRepository>(context),
                  ),
                  child: const PinSetupScreen(),
                ),
              ),
            ),
            GoRoute(
              path: 'account-setup',
              name: accountSetup,
              pageBuilder: pageBuilder(
                child: const AccountSetupSuccessScreen(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
