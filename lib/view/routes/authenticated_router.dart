import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/logic/cubit/password_change_form/password_change_form_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/routes/guards/protected_guard.dart';
import 'package:simplio_app/view/routes/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/routes/observers/tab_bar_observer.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';
import 'package:simplio_app/view/screens/account_setup_success_screen.dart';
import 'package:simplio_app/view/screens/application_screen.dart';
import 'package:simplio_app/view/screens/configuration_screen.dart';
import 'package:simplio_app/view/screens/dapps_screen.dart';
import 'package:simplio_app/view/screens/discovery_screen.dart';
import 'package:simplio_app/view/screens/games_screen.dart';
import 'package:simplio_app/view/screens/inventory_screen.dart';
import 'package:simplio_app/view/screens/password_change_screen.dart';
import 'package:simplio_app/view/screens/pin_setup_screen.dart';

class AuthenticatedRouter with PageBuilderMixin {
  static const String discovery = 'discovery';
  static const String games = 'games';
  static const String inventory = 'inventory';
  static const String inventoryCoins = 'inventory-coins';
  static const String inventoryNft = 'inventory-nft';
  static const String inventoryTransactions = 'inventory-transactions';
  static const String configuration = 'configuration';
  static const String findDapps = 'find-dapps';
  static const String pinSetup = 'pin-setup';
  static const String accountSetup = 'account-setup';
  static const String passwordChange = 'password-change';

  final BuildContext context;

  AuthenticatedRouter.of(this.context);

  GoRouter get router {
    return GoRouter(
      initialLocation: '/in',
      // TODO - Replace this param with [ShellRoute] on go_router v5 migration
      // See https://github.com/flutter/flutter/issues/108141
      navigatorBuilder: (_, __, child) {
        return ProtectedGuard(
          protectWhen: (state) =>
              state.account.securityLevel.index > SecurityLevel.none.index &&
              state is AccountLocked,
          protectedBuilder: (_) =>
              BlocBuilder<AccountWalletCubit, AccountWalletState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              if (state is AccountWalletProvided) {
                return ApplicationScreen(child: child);
              }

              if (state is AccountWalletLoading ||
                  state is AccountWalletLoadedWithError) {
                return const ApplicationLoadingScreen();
              }

              return child;
            },
          ),
          onPrevent: (context) {
            context.read<AuthBloc>().add(const GotUnauthenticated());
          },
        );
      },
      observers: [
        TabBarObserver.of(context),
      ],
      routes: [
        GoRoute(
          path: '/in',
          redirect: (state) {
            final accountState = context.read<AccountCubit>().state;

            if (accountState is AccountProvided) {
              final index = accountState.account.securityLevel.index;
              if (index <= SecurityLevel.none.index) return '/set/pin-setup';
            }

            return '/in/discovery';
          },
          routes: [
            GoRoute(
              path: 'discovery',
              name: discovery,
              pageBuilder: pageBuilder(
                child: const DiscoveryScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: const ValueKey(discovery),
                  ),
                ),
              ),
            ),
            GoRoute(
                path: 'inventory',
                name: inventory,
                pageBuilder: pageBuilder(
                  child: BlocProvider(
                    create: (context) => CryptoAssetCubit.builder(
                      assetRepository:
                          RepositoryProvider.of<AssetRepository>(context),
                    ),
                    child: Builder(builder: (context) {
                      return const InventoryScreen();
                    }),
                  ),
                  withTransition: false,
                  settings: ApplicationSettings(
                    tabBar: TabBarRouteSettings(
                      selectedKey: const ValueKey(inventory),
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'coins',
                    name: inventoryCoins,
                    pageBuilder: pageBuilder(
                      child: BlocProvider(
                        create: (context) => CryptoAssetCubit.builder(
                          assetRepository:
                              RepositoryProvider.of<AssetRepository>(context),
                        ),
                        child: Builder(builder: (context) {
                          return const InventoryScreen(
                            inventoryTab: InventoryTab.coins,
                          );
                        }),
                      ),
                      withTransition: false,
                      settings: ApplicationSettings(
                        tabBar: TabBarRouteSettings(
                          selectedKey: const ValueKey(inventory),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'nft',
                    name: inventoryNft,
                    pageBuilder: pageBuilder(
                      child: BlocProvider(
                        create: (context) => CryptoAssetCubit.builder(
                          assetRepository:
                              RepositoryProvider.of<AssetRepository>(context),
                        ),
                        child: Builder(builder: (context) {
                          return const InventoryScreen(
                            inventoryTab: InventoryTab.nft,
                          );
                        }),
                      ),
                      withTransition: false,
                      settings: ApplicationSettings(
                        tabBar: TabBarRouteSettings(
                          selectedKey: const ValueKey(inventory),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'transactions',
                    name: inventoryTransactions,
                    pageBuilder: pageBuilder(
                      child: BlocProvider(
                        create: (context) => CryptoAssetCubit.builder(
                          assetRepository:
                              RepositoryProvider.of<AssetRepository>(context),
                        ),
                        child: Builder(builder: (context) {
                          return const InventoryScreen(
                            inventoryTab: InventoryTab.transactions,
                          );
                        }),
                      ),
                      withTransition: false,
                      settings: ApplicationSettings(
                        tabBar: TabBarRouteSettings(
                          selectedKey: const ValueKey(inventory),
                        ),
                      ),
                    ),
                  ),
                ]),
            GoRoute(
              path: 'games',
              name: games,
              pageBuilder: pageBuilder(
                child: const GamesScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: const ValueKey(games),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'find-dapps',
              name: findDapps,
              pageBuilder: pageBuilder(
                child: const DappsScreen(),
                withTransition: false,
                settings: ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: const ValueKey(findDapps),
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
                  tabBar: TabBarRouteSettings(
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
                      tabBar: TabBarRouteSettings(
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
                        protectedBuilder: (_) => const PasswordChangeScreen(),
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
