import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/data/repositories/games_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
import 'package:simplio_app/logic/cubit/password_change_form/password_change_form_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/routes/guards/protected_guard.dart';
import 'package:simplio_app/view/routes/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/routes/observers/tab_bar_observer.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';
import 'package:simplio_app/view/screens/account_setup_success_screen.dart';
import 'package:simplio_app/view/screens/application_screen.dart';
import 'package:simplio_app/view/screens/asset_detail_screen.dart';
import 'package:simplio_app/view/screens/asset_receive_screen.dart';
import 'package:simplio_app/view/screens/asset_search_screen.dart';
import 'package:simplio_app/view/screens/asset_send_screen.dart';
import 'package:simplio_app/view/screens/asset_send_summary_screen.dart';
import 'package:simplio_app/view/screens/configuration_screen.dart';
import 'package:simplio_app/view/screens/dapps_screen.dart';
import 'package:simplio_app/view/screens/discovery_screen.dart';
import 'package:simplio_app/view/screens/games_screen.dart';
import 'package:simplio_app/view/screens/games_search_screen.dart';
import 'package:simplio_app/view/screens/inventory_screen.dart';
import 'package:simplio_app/view/screens/password_change_screen.dart';
import 'package:simplio_app/view/screens/pin_setup_screen.dart';
import 'package:simplio_app/view/screens/qr_code_scanner_screen.dart';
import 'package:simplio_app/view/screens/transaction_success_screen.dart';

class AuthenticatedRouter with PageBuilderMixin {
  static const String discovery = 'discovery';
  static const String games = 'games';
  static const String gamesSearch = 'games-search';
  static const String inventory = 'inventory';
  static const String inventoryCoins = 'inventory-coins';
  static const String inventoryNft = 'inventory-nft';
  static const String inventoryTransactions = 'inventory-transactions';
  static const String configuration = 'configuration';
  static const String findDapps = 'find-dapps';
  static const String pinSetup = 'pin-setup';
  static const String accountSetup = 'account-setup';
  static const String passwordChange = 'password-change';
  static const String assetDetail = 'asset-detail';
  static const String assetSearch = 'asset-search';
  static const String assetSend = 'asset-send';
  static const String assetSendSummary = 'asset-send-summary';
  static const String assetSendSuccess = 'asset-send-success';
  static const String assetReceive = 'asset-receive';
  static const String qrCodeScanner = 'qr-code-scanner';

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
                builder: (state) => const DiscoveryScreen(),
                withTransition: false,
                settings: const ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: ValueKey(discovery),
                  ),
                ),
              ),
            ),
            GoRoute(
                path: 'inventory',
                name: inventory,
                pageBuilder: pageBuilder(
                  builder: (state) => BlocProvider(
                    create: (context) => CryptoAssetCubit.builder(
                      assetRepository:
                          RepositoryProvider.of<AssetRepository>(context),
                    ),
                    child: Builder(builder: (context) {
                      return const InventoryScreen();
                    }),
                  ),
                  withTransition: false,
                  settings: const ApplicationSettings(
                    tabBar: TabBarRouteSettings(
                      selectedKey: ValueKey(inventory),
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'coins',
                    name: inventoryCoins,
                    pageBuilder: pageBuilder(
                      builder: (state) => BlocProvider(
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
                      settings: const ApplicationSettings(
                        tabBar: TabBarRouteSettings(
                          selectedKey: ValueKey(inventory),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'nft',
                    name: inventoryNft,
                    pageBuilder: pageBuilder(
                      builder: (state) => BlocProvider(
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
                      settings: const ApplicationSettings(
                        tabBar: TabBarRouteSettings(
                          selectedKey: ValueKey(inventory),
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'transactions',
                    name: inventoryTransactions,
                    pageBuilder: pageBuilder(
                      builder: (state) => BlocProvider(
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
                      settings: const ApplicationSettings(
                        tabBar: TabBarRouteSettings(
                          selectedKey: ValueKey(inventory),
                        ),
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: 'success',
                        name: assetSendSuccess,
                        pageBuilder: pageBuilder(
                          builder: (state) => BlocProvider(
                            create: (context) => AssetSendFormCubit.builder(
                              initialState: state.extra as AssetSendFormState,
                            ),
                            child: Builder(
                              builder: (context) =>
                                  const TransactionSuccessScreen(),
                            ),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':assetId/:networkId/detail',
                    name: assetDetail,
                    pageBuilder: pageBuilder(
                      builder: (state) => AssetDetailScreen(
                        assetId: state.params['assetId'],
                        networkId: state.params['networkId'],
                      ),
                      settings: const ApplicationSettings.hiddenTabBar(),
                    ),
                  ),
                  GoRoute(
                    path: ':assetId/:networkId/send',
                    name: assetSend,
                    pageBuilder: pageBuilder(
                      builder: (state) => BlocProvider(
                        create: (context) => AssetSendFormCubit.builder(
                            initialState: state.extra as AssetSendFormState?),
                        child: Builder(
                          builder: (context) => AssetSendScreen(
                            assetId: state.params['assetId'],
                            networkId: state.params['networkId'],
                          ),
                        ),
                      ),
                      settings: const ApplicationSettings.hiddenTabBar(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'summary',
                        name: assetSendSummary,
                        pageBuilder: pageBuilder(
                          builder: (state) => BlocProvider(
                            create: (context) => AssetSendFormCubit.builder(
                              initialState: state.extra as AssetSendFormState,
                            ),
                            child: Builder(
                              builder: (context) =>
                                  const AssetSendSummaryScreen(),
                            ),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':assetId/:networkId/receive',
                    name: assetReceive,
                    pageBuilder: pageBuilder(
                      builder: (state) => AssetReceiveScreen(
                        assetId: state.params['assetId'],
                        networkId: state.params['networkId'],
                      ),
                    ),
                  ),
                ]),
            GoRoute(
              path: 'games',
              name: games,
              pageBuilder: pageBuilder(
                builder: (state) => const GamesScreen(),
                withTransition: false,
                settings: const ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: ValueKey(games),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'find-dapps',
              name: findDapps,
              pageBuilder: pageBuilder(
                builder: (state) => const DappsScreen(),
                withTransition: false,
                settings: const ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: ValueKey(findDapps),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'configuration',
              name: configuration,
              pageBuilder: pageBuilder(
                builder: (state) => const ConfigurationScreen(),
                withTransition: false,
                settings: const ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    selectedKey: ValueKey(configuration),
                  ),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'password-change',
                  name: passwordChange,
                  pageBuilder: pageBuilder(
                    settings: const ApplicationSettings(
                      tabBar: TabBarRouteSettings(
                        selectedKey: ValueKey(configuration),
                        isVisible: false,
                      ),
                    ),
                    builder: (state) => BlocProvider(
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
            GoRoute(
              path: 'asset-search',
              name: assetSearch,
              pageBuilder: pageBuilder(
                builder: (state) => BlocProvider(
                  create: (context) => CryptoAssetCubit.builder(
                    assetRepository:
                        RepositoryProvider.of<AssetRepository>(context),
                  ),
                  child: Builder(
                    builder: (context) {
                      return AssetSearchScreen();
                    },
                  ),
                ),
                settings: const ApplicationSettings.hiddenTabBar(),
              ),
            ),
            GoRoute(
              path: 'games-search',
              name: gamesSearch,
              pageBuilder: pageBuilder(
                builder: (state) => BlocProvider(
                  create: (context) => GamesCubit.builder(
                    gamesRepository:
                        RepositoryProvider.of<GamesRepository>(context),
                  ),
                  child: Builder(
                    builder: (context) {
                      return const GamesSearchScreen();
                    },
                  ),
                ),
                settings: const ApplicationSettings.hiddenTabBar(),
              ),
            ),
            GoRoute(
              path: 'qr-code-scanner',
              name: qrCodeScanner,
              pageBuilder: pageBuilder(
                builder: (state) => const QrCodeScannerScreen(),
              ),
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
                builder: (state) => BlocProvider(
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
                builder: (state) => const AccountSetupSuccessScreen(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
