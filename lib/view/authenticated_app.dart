import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/asset_wallet_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/tap_bar/tap_bar_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/dark_mode.dart';
import 'package:simplio_app/view/themes/light_mode.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

class AuthenticatedApp extends StatelessWidget {
  final String accountId;

  const AuthenticatedApp({
    super.key,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    TrustWalletCoreLib.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountCubit.builder(
            accountRepository:
                RepositoryProvider.of<AccountRepository>(context),
            assetWalletRepository:
                RepositoryProvider.of<AssetWalletRepository>(context),
          )..loadAccount(accountId),
        ),
        BlocProvider(create: (_) => TapBarCubit()),
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
                theme: LightMode.theme,
                darkTheme: DarkMode.theme,
                routeInformationParser: r.routeInformationParser,
                routeInformationProvider: r.routeInformationProvider,
                routerDelegate: r.routerDelegate,
              );
            },
          );
        },
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
    return context.watch<AccountCubit>().state.account?.settings.locale ??
        const AccountSettings.preset().locale;
  }

  ThemeMode _setThemeMode(BuildContext context) {
    final th = context.watch<AccountCubit>().state.account?.settings.themeMode;

    _setSystemUIOverlayStyle(th);
    return th ?? const AccountSettings.preset().themeMode;
  }
}
