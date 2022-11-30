import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/buy_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/inventory_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/logic/cubit/tab_bar/tab_bar_cubit.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

class AuthenticatedApp extends StatelessWidget {
  final String accountId;

  const AuthenticatedApp({
    super.key,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountCubit.builder(
            accountRepository:
                RepositoryProvider.of<AccountRepository>(context),
          )..loadAccount(accountId),
        ),
        BlocProvider(
          create: (context) => AccountWalletCubit.builder(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
            inventoryRepository:
                RepositoryProvider.of<InventoryRepository>(context),
            swapRepository: RepositoryProvider.of<SwapRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => WalletConnectCubit(
            feeRepository: RepositoryProvider.of<FeeRepository>(context),
            walletConnectRepository:
                RepositoryProvider.of<WalletConnectRepository>(context),
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          ),
        ),
        BlocProvider(create: (_) => TabBarCubit()),
        BlocProvider(
          create: (context) => AssetExchangeFormCubit(
            swapRepository: RepositoryProvider.of<SwapRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => AssetSendFormCubit.builder(
            feeRepository: RepositoryProvider.of<FeeRepository>(context),
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => AssetBuyFormCubit.builder(
            buyRepository: RepositoryProvider.of<BuyRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => GamesBloc.builder(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            marketplaceRepository:
                RepositoryProvider.of<MarketplaceRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => CryptoAssetBloc.builder(
            marketplaceRepository:
                RepositoryProvider.of<MarketplaceRepository>(context),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AccountCubit, AccountState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is! AccountUnlocked) return;
              context
                  .read<AccountWalletCubit>()
                  .loadWallet(state.account.id, key: state.secret);
            },
          ),
          BlocListener<AccountWalletCubit, AccountWalletState>(
            listener: (context, state) {
              if (state is AccountWalletLoaded) {
                context
                    .read<WalletConnectCubit>()
                    .loadSessions(state.wallet.uuid);
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final r = AuthenticatedRouter.of(context).router;
            return Builder(
              builder: (context) {
                return MaterialApp.router(
                  key: UniqueKey(),
                  onGenerateTitle: (context) => context.locale.simplioTitle,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: _setLocale(context),
                  themeMode: _setThemeMode(context),
                  routeInformationParser: r.routeInformationParser,
                  routeInformationProvider: r.routeInformationProvider,
                  routerDelegate: r.routerDelegate,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _setSystemUIOverlayStyle(ThemeMode? mode) {
    SystemChrome.setSystemUIOverlayStyle(
      mode == ThemeMode.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }

  Locale _setLocale(BuildContext context) {
    final s = context.watch<AccountCubit>().state;
    return s is AccountProvided
        ? s.account.settings.locale
        : const AccountSettings.builder().locale;
  }

  ThemeMode _setThemeMode(BuildContext context) {
    final ThemeMode themeMode;
    final s = context.watch<AccountCubit>().state;

    if (s is AccountProvided) {
      _setSystemUIOverlayStyle(s.account.settings.themeMode);
      themeMode = s.account.settings.themeMode;
    } else {
      themeMode = const AccountSettings.builder().themeMode;
    }

    globalThemeMode = themeMode;
    return themeMode;
  }

  void init() {
    TrustWalletCoreLib.init();
  }
}
