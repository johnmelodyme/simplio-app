import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/crypto_asset/crypto_asset_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
import 'package:simplio_app/logic/cubit/password_change_form/password_change_form_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/routes/guards/protected_guard.dart';
import 'package:simplio_app/view/routes/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/routes/observers/tab_bar_observer.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';
import 'package:simplio_app/view/screens/account_setup_success_screen.dart';
import 'package:simplio_app/view/screens/application_screen.dart';
import 'package:simplio_app/view/screens/asset_buy_confirmation_screen.dart';
import 'package:simplio_app/view/screens/asset_buy_payment_gateway_screen.dart';
import 'package:simplio_app/view/screens/asset_buy_screen.dart';
import 'package:simplio_app/view/screens/asset_buy_search_screen.dart';
import 'package:simplio_app/view/screens/asset_buy_success_screen.dart';
import 'package:simplio_app/view/screens/asset_buy_summary_screen.dart';
import 'package:simplio_app/view/screens/asset_detail_screen.dart';
import 'package:simplio_app/view/screens/asset_exchange_screen.dart';
import 'package:simplio_app/view/screens/asset_exchange_search_screen.dart';
import 'package:simplio_app/view/screens/asset_exchange_success_screen.dart';
import 'package:simplio_app/view/screens/asset_exchange_summary_screen.dart';
import 'package:simplio_app/view/screens/asset_receive_screen.dart';
import 'package:simplio_app/view/screens/asset_search_screen.dart';
import 'package:simplio_app/view/screens/asset_send_qr_scanner_screen.dart';
import 'package:simplio_app/view/screens/asset_send_screen.dart';
import 'package:simplio_app/view/screens/asset_send_search_screen.dart';
import 'package:simplio_app/view/screens/asset_send_success_screen.dart';
import 'package:simplio_app/view/screens/asset_send_summary_screen.dart';
import 'package:simplio_app/view/screens/backup_inventory_screen.dart';
import 'package:simplio_app/view/screens/configuration_screen.dart';
import 'package:simplio_app/view/screens/configuration_security_screen.dart';
import 'package:simplio_app/view/screens/dapps_screen.dart';
import 'package:simplio_app/view/screens/discovery_screen.dart';
import 'package:simplio_app/view/screens/gameplay_screen.dart';
import 'package:simplio_app/view/screens/games_screen.dart';
import 'package:simplio_app/view/screens/games_search_screen.dart';
import 'package:simplio_app/view/screens/inventory_screen.dart';
import 'package:simplio_app/view/screens/password_change_screen.dart';
import 'package:simplio_app/view/screens/pin_setup_screen.dart';
import 'package:simplio_app/view/screens/wallet_connect_qr_code_scanner_screen.dart';
import 'package:simplio_app/view/widgets/account_created_icon.dart';
import 'package:simplio_app/view/widgets/lock_with_shadow_icon.dart';

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
  static const String securitySettings = 'security-settings';
  static const String passwordChange = 'password-change';
  static const String backupInventory = 'backup-inventory';
  static const String assetDetail = 'asset-detail';
  static const String assetSearch = 'asset-search';
  static const String gameplay = 'gameplay';

  static const String assetSend = 'asset-send';
  static const String assetSendQrScanner = 'asset-send-qr-scanner';
  static const String assetSendSearch = 'asset-send-search';
  static const String assetSendSummary = 'asset-send-summary';
  static const String assetSendSuccess = 'asset-send-success';

  static const String assetReceive = 'asset-receive';

  static const String assetExchange = 'asset-exchange';
  static const String assetExchangeSearchFrom = 'asset-exchange-search-from';
  static const String assetExchangeSearchTarget =
      'asset-exchange-search-target';
  static const String assetExchangeSummary = 'asset-exchange-summary';
  static const String assetExchangeSuccess = 'asset-exchange-success';

  static const String assetBuy = 'asset-buy';
  static const String assetBuySearch = 'asset-buy-search';
  static const String assetBuySummary = 'asset-buy-summary';
  static const String assetBuyConfirmation = 'asset-buy-confirmation';
  static const String assetBuyPaymentGateway = 'asset-buy-payment-gateway';
  static const String assetBuySuccess = 'asset-buy-success';

  static const String walletConnectQrCodeScanner =
      'wallet-connect-qr-code-scanner';

  final BuildContext context;

  AuthenticatedRouter.of(this.context);

  GoRouter get router {
    return GoRouter(
      initialLocation: '/in',
      // TODO - Replace this param with [ShellRoute] on go_router v5 migration
      // See https://github.com/flutter/flutter/issues/108141
      navigatorBuilder: (context, __, child) {
        return ProtectedGuard(
          icon: const AccountCreatedIcon(),
          title: context.locale.pin_setup_screen_account_creation_title,
          subtitle: context.locale.pin_setup_screen_account_creation_subtitle,
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
                  builder: (state) => BlocProvider(
                    create: (context) => DialogCubit.builder(),
                    child: DiscoveryScreen(),
                  ),
                  withTransition: false,
                  settings: const ApplicationSettings(
                    tabBar: TabBarRouteSettings(
                      selectedKey: ValueKey(discovery),
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'configuration',
                    name: configuration,
                    pageBuilder: pageBuilder(
                      builder: (state) => const ConfigurationScreen(
                        key: ValueKey(configuration),
                      ),
                      withTransition: false,
                      settings: const ApplicationSettings.hiddenTabBar(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'security-settings',
                        name: securitySettings,
                        pageBuilder: pageBuilder(
                          builder: (state) => const ConfigurationSecurityScreen(
                            key: ValueKey(securitySettings),
                          ),
                          withTransition: false,
                          settings: const ApplicationSettings.hiddenTabBar(),
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
                                create: (context) =>
                                    PasswordChangeFormCubit.builder(
                                  authRepository:
                                      RepositoryProvider.of<AuthRepository>(
                                          context),
                                ),
                                child: Builder(builder: (context) {
                                  return ProtectedGuard(
                                    icon: const LockWithShadowIcon(),
                                    title: context
                                        .locale.protected_guard_enter_pin_code,
                                    protectedBuilder: (_) =>
                                        const PasswordChangeScreen(),
                                    onPrevent: (context) =>
                                        context.goNamed(securitySettings),
                                  );
                                }),
                              ),
                            ),
                          ),
                          GoRoute(
                            path: 'backup-inventory',
                            name: backupInventory,
                            pageBuilder: pageBuilder(
                              settings: const ApplicationSettings(
                                tabBar: TabBarRouteSettings(
                                  selectedKey: ValueKey(backupInventory),
                                  isVisible: false,
                                ),
                              ),
                              builder: (state) => BlocProvider(
                                create: (context) =>
                                    PasswordChangeFormCubit.builder(
                                  authRepository:
                                      RepositoryProvider.of<AuthRepository>(
                                          context),
                                ),
                                child: Builder(builder: (context) {
                                  return ProtectedGuard(
                                    icon: const LockWithShadowIcon(),
                                    title: context
                                        .locale.protected_guard_enter_pin_code,
                                    protectedBuilder: (_) =>
                                        const BackupInventoryScreen(),
                                    onPrevent: (context) =>
                                        context.goNamed(securitySettings),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
            GoRoute(
                path: 'inventory',
                name: inventory,
                pageBuilder: pageBuilder(
                  builder: (state) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => CryptoAssetCubit.builder(
                          marketplaceRepository:
                              RepositoryProvider.of<MarketplaceRepository>(
                                  context),
                        ),
                      ),
                      BlocProvider(
                          create: (context) => ExpansionListCubit.builder()),
                    ],
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
                          marketplaceRepository:
                              RepositoryProvider.of<MarketplaceRepository>(
                                  context),
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
                          marketplaceRepository:
                              RepositoryProvider.of<MarketplaceRepository>(
                                  context),
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
                          marketplaceRepository:
                              RepositoryProvider.of<MarketplaceRepository>(
                                  context),
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
                      builder: (state) => Builder(
                        builder: (context) => AssetSendScreen(
                          sourceAssetId: state.params['assetId'],
                          sourceNetworkId: state.params['networkId'],
                        ),
                      ),
                      settings: const ApplicationSettings.hiddenTabBar(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'search',
                        name: assetSendSearch,
                        pageBuilder: pageBuilder(
                          builder: (state) => BlocProvider(
                            create: (context) => ExpansionListCubit.builder(),
                            child: AssetSendSearchScreen(
                              assetId: state.params['assetId']!,
                              networkId: state.params['networkId']!,
                            ),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'qr-scanner',
                        name: assetSendQrScanner,
                        pageBuilder: pageBuilder(
                          builder: (state) => const AssetSendQrScannerScreen(),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'summary',
                        name: assetSendSummary,
                        pageBuilder: pageBuilder(
                          builder: (state) => Builder(
                            builder: (context) =>
                                const AssetSendSummaryScreen(),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'success',
                        name: assetSendSuccess,
                        pageBuilder: pageBuilder(
                          builder: (state) => Builder(
                            builder: (context) =>
                                const AssetSendSuccessScreen(),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':assetId/:networkId/exchange',
                    name: assetExchange,
                    pageBuilder: pageBuilder(
                      builder: (state) => AssetExchangeScreen(
                        sourceAssetId: state.params['assetId'],
                        sourceNetworkId: state.params['networkId'],
                      ),
                      settings: const ApplicationSettings.hiddenTabBar(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'search-from',
                        name: assetExchangeSearchFrom,
                        pageBuilder: pageBuilder(
                          builder: (state) => BlocProvider(
                            create: (context) => ExpansionListCubit.builder(),
                            child: AssetExchangeSearchScreen(
                              assetId: state.params['assetId']!,
                              networkId: state.params['networkId']!,
                              fromSearch: true,
                              targetSearch: false,
                            ),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'search-target',
                        name: assetExchangeSearchTarget,
                        pageBuilder: pageBuilder(
                          builder: (state) => BlocProvider(
                            create: (context) => ExpansionListCubit.builder(),
                            child: AssetExchangeSearchScreen(
                              assetId: state.params['assetId']!,
                              networkId: state.params['networkId']!,
                              fromSearch: false,
                              targetSearch: true,
                            ),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'summary',
                        name: assetExchangeSummary,
                        pageBuilder: pageBuilder(
                          builder: (state) =>
                              const AssetExchangeSummaryScreen(),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'success',
                        name: assetExchangeSuccess,
                        pageBuilder: pageBuilder(
                          builder: (state) =>
                              const AssetExchangeSuccessScreen(),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':assetId/:networkId/buy',
                    name: assetBuy,
                    pageBuilder: pageBuilder(
                      builder: (state) => AssetBuyScreen(
                        assetId: state.params['assetId'],
                        networkId: state.params['networkId'],
                      ),
                      settings: const ApplicationSettings.hiddenTabBar(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'search',
                        name: assetBuySearch,
                        pageBuilder: pageBuilder(
                          builder: (state) => BlocProvider(
                            create: (context) => ExpansionListCubit.builder(),
                            child: AssetBuySearchScreen(
                              assetId: state.params['assetId']!,
                              networkId: state.params['networkId']!,
                            ),
                          ),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'summary',
                        name: assetBuySummary,
                        pageBuilder: pageBuilder(
                          builder: (state) => const AssetBuySummaryScreen(),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'confirmation',
                        name: assetBuyConfirmation,
                        pageBuilder: pageBuilder(
                          builder: (state) =>
                              const AssetBuyConfirmationScreen(),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'payment-gateway',
                        name: assetBuyPaymentGateway,
                        pageBuilder: pageBuilder(
                          builder: (state) =>
                              const AssetBuyPaymentGateWayScreen(),
                          settings: const ApplicationSettings.hiddenTabBar(),
                        ),
                      ),
                      GoRoute(
                        path: 'success',
                        name: assetBuySuccess,
                        pageBuilder: pageBuilder(
                          builder: (state) => const AssetBuySuccessScreen(),
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
              path: 'gameplay',
              name: gameplay,
              pageBuilder: pageBuilder(
                builder: (state) => GameplayScreen(
                  game: state.extra as Game,
                ),
                settings: const ApplicationSettings(
                  tabBar: TabBarRouteSettings(
                    isVisible: false,
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'asset-search',
              name: assetSearch,
              pageBuilder: pageBuilder(
                builder: (state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => CryptoAssetCubit.builder(
                        marketplaceRepository:
                            RepositoryProvider.of<MarketplaceRepository>(
                                context),
                      ),
                    ),
                    BlocProvider(
                        create: (context) => ExpansionListCubit.builder()),
                    BlocProvider(create: (context) => DialogCubit.builder()),
                  ],
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
                    marketplaceRepository:
                        RepositoryProvider.of<MarketplaceRepository>(context),
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
              path: 'wallet-connect-qr-code-scanner',
              name: walletConnectQrCodeScanner,
              pageBuilder: pageBuilder(
                builder: (state) => const WalletConnectQrCodeScannerScreen(),
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
