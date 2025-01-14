import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/logic/bloc/games/my_games_bloc.dart';
import 'package:simplio_app/logic/bloc/nft/nft_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/routers/authenticated_router.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

class AuthenticatedApp extends StatelessWidget {
  static GoRouter get router => AuthenticatedRouter().router;

  final Account account;

  const AuthenticatedApp({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountCubit(
            accountRepository:
                RepositoryProvider.of<AccountRepository>(context),
          )..loadAccount(account),
        ),
        BlocProvider(
          create: (context) => AccountWalletCubit(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
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
        BlocProvider(
          create: (context) => GamesBloc.builder(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            marketplaceRepository:
                RepositoryProvider.of<MarketplaceRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => MyGamesBloc(
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
        BlocProvider(
          create: (context) => NftBloc.builder(
            marketplaceRepository:
                RepositoryProvider.of<MarketplaceRepository>(context),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AccountCubit, AccountState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) async {
              if (state is! AccountUnlocked) return;
              if (state.isLoaded) return;

              await context
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
        child: Builder(builder: (context) {
          return MaterialApp.router(
            key: UniqueKey(),
            onGenerateTitle: (context) => context.locale.simplioTitle,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: _setLocale(context),
            themeMode: _setThemeMode(context),
            routerConfig: router,
          );
        }),
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
    // TODO - BUG - don't use `watch` method to monitor state. It rebuilds the entire widget tree everytime the account is changed.
    final s = context.read<AccountCubit>().state;
    return s is AccountProvided
        ? s.account.settings.locale
        : const AccountSettings().locale;
  }

  ThemeMode _setThemeMode(BuildContext context) {
    final ThemeMode themeMode;
    // TODO - BUG - don't use `watch` method to monitor state.
    final s = context.read<AccountCubit>().state;

    if (s is AccountProvided) {
      _setSystemUIOverlayStyle(s.account.settings.themeMode);
      themeMode = s.account.settings.themeMode;
    } else {
      themeMode = const AccountSettings().themeMode;
    }

    globalThemeMode = themeMode;
    return themeMode;
  }

  void init(BuildContext context) {
    precacheImage(
      Image.asset('assets/images/simpliona_dapps.png').image,
      context,
    );
    precacheImage(
      Image.asset('assets/images/find_dapps_coming_soon.png').image,
      context,
    );
    precacheImage(
      Image.asset('assets/images/blue_ring.png').image,
      context,
    );
    precacheImage(
      Image.asset('assets/images/empty_transactions_placeholder.png').image,
      context,
    );

    TrustWalletCoreLib.init();
  }
}
