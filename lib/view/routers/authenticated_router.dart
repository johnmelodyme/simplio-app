import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/guards/protected_guard.dart';
import 'package:simplio_app/view/routers/authenticated_routes/account_setup_failure_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/account_setup_success_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_detail_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_receive_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_send_form_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_send_summary_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_swap_form_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_swap_summary_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/backup_inventory_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/configuration_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/configuration_security_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/discovery_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/find_dapps_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/game_detail_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/gameplay_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/games_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/inventory_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/password_change_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/pin_setup_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/wallet_connect_qr_scanner_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/application_loading_screen.dart';
import 'package:simplio_app/view/screens/not_found_screen.dart';
import 'package:simplio_app/view/shells/app_bar_shell.dart';
import 'package:simplio_app/view/shells/tab_bar_shell.dart';
import 'package:simplio_app/view/shells/wallet_connect_shell.dart';
import 'package:simplio_app/view/widgets/lock_with_shadow_icon.dart';

class AuthenticatedRouter {
  AuthenticatedRouter();

  final navRoot = GlobalKey<NavigatorState>();
  final navWalletConnect = GlobalKey<NavigatorState>();
  final navTabBar = GlobalKey<NavigatorState>();
  final navAppBar = GlobalKey<NavigatorState>();

  GoRouter get router {
    return GoRouter(
      navigatorKey: navRoot,
      initialLocation: DiscoveryRoute.path,
      debugLogDiagnostics: true,
      errorBuilder: (context, state) => const NotFoundScreen(),
      redirect: (context, state) {
        final s = context.read<AccountCubit>().state;
        if (s is! AccountProvided) {
          return '/set/${AccountSetupFailureRoute.path}';
        }

        if (s.account.securityLevel.index <= SecurityLevel.none.index) {
          return '/set/${PinSetupRoute.path}';
        }

        return null;
      },
      routes: [
        ShellRoute(
          navigatorKey: navWalletConnect,
          builder: (context, __, child) {
            return ProtectedGuard(
              icon: const LockWithShadowIcon(),
              title: context.locale.protected_guard_enter_pin_code,
              displayAppBar: false,
              protectWhen: (state) {
                return state.account.securityLevel.index >
                        SecurityLevel.none.index &&
                    state is AccountLocked;
              },
              protectedBuilder: (_) =>
                  BlocBuilder<AccountWalletCubit, AccountWalletState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is AccountWalletProvided) {
                    return WalletConnectShell(child: child);
                  }

                  return const ApplicationLoadingScreen();
                },
              ),
              onPrevent: (context) {
                context.read<AuthBloc>().add(const GotUnauthenticated());
              },
            );
          },
          routes: [
            ShellRoute(
              navigatorKey: navTabBar,
              builder: (_, state, child) {
                return TabBarShell(
                  path: state.location,
                  child: child,
                );
              },
              routes: [
                ShellRoute(
                  navigatorKey: navAppBar,
                  builder: (_, state, child) {
                    return AppBarShell(
                      child: child,
                    );
                  },
                  routes: [
                    DiscoveryRoute(
                      navigator: navAppBar,
                    ).route,
                    GamesRoute(
                      navigator: navAppBar,
                    ).route,
                    InventoryRoute(
                      navigator: navAppBar,
                    ).route,
                    FindDappsRoute(
                      navigator: navAppBar,
                    ).route,
                  ],
                ),
              ],
            ),
            GameplayRoute(
              navigator: navWalletConnect,
            ).route,
            GameDetailRoute(
              navigator: navWalletConnect,
            ).route,
            AssetDetailRoute(
              navigator: navWalletConnect,
            ).route,
            AssetReceiveRoute(
              navigator: navWalletConnect,
            ).route,
            AssetSendFormRoute(
              navigator: navWalletConnect,
              routes: [
                AssetSendSummaryRoute(
                  navigator: navWalletConnect,
                ).route,
              ],
            ).route,
            AssetSwapFormRoute(
              navigator: navWalletConnect,
              routes: [
                AssetSwapSummaryRoute(
                  navigator: navWalletConnect,
                ).route,
              ],
            ).route,
            WalletConnectQrScannerRoute(
              navigator: navWalletConnect,
            ).route,
            ConfigurationRoute(
              navigator: navWalletConnect,
              routes: [
                ConfigurationSecurityRoute(
                  navigator: navWalletConnect,
                  routes: [
                    PasswordChangeRoute(
                      navigator: navWalletConnect,
                    ).route,
                    BackupInventoryRoute(
                      navigator: navWalletConnect,
                    ).route,
                  ],
                ).route,
              ],
            ).route,
          ],
        ),
        GoRoute(
          path: '/set',
          builder: (_, __) => const SizedBox.shrink(),
          routes: [
            PinSetupRoute(
              navigator: navRoot,
            ).route,
            AccountSetupSuccessRoute(
              navigator: navRoot,
            ).route,
            AccountSetupFailureRoute(
              navigator: navRoot,
            ).route,
          ],
        ),
      ],
    );
  }
}
