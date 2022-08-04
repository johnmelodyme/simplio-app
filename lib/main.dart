import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simplio_app/data/http/clients/public_http_client.dart';
import 'package:simplio_app/data/http/clients/secured_http_client.dart';
import 'package:simplio_app/data/http/services/password_change_service.dart';
import 'package:simplio_app/data/http/services/password_reset_service.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/http/services/sign_in_service.dart';
import 'package:simplio_app/data/http/services/sign_up_service.dart';
import 'package:simplio_app/data/providers/account_db_provider.dart';
import 'package:simplio_app/data/providers/asset_wallet_db_provider.dart';
import 'package:simplio_app/data/providers/auth_token_db_provider.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/asset_wallet_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/loading/loading_cubit.dart';
import 'package:simplio_app/view/authenticated_app.dart';
import 'package:simplio_app/view/routes/guards/auth_guard.dart';
import 'package:simplio_app/view/screens/splash_screen.dart';
import 'package:simplio_app/view/unauthenticated_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SimplioApp());
}

class SimplioApp extends StatefulWidget {
  const SimplioApp({super.key});

  @override
  State<SimplioApp> createState() => _SimplioAppState();
}

class _SimplioAppState extends State<SimplioApp> {
  late AccountRepository accountRepository;
  late AssetWalletRepository assetWalletRepository;
  late AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingCubit.builder(),
      child: BlocBuilder<LoadingCubit, LoadingState>(
        buildWhen: (prev, curr) =>
            prev.displaySplashScreen != curr.displaySplashScreen,
        builder: (context, state) => state.displaySplashScreen
            ? SplashScreen(loadingFunction: _appInitializationActions)
            : _mainApp(),
      ),
    );
  }

  Widget _mainApp() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: accountRepository),
        RepositoryProvider.value(value: assetWalletRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc.builder(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            )..add(GotLastAuthenticated()),
          ),
        ],
        child: AuthGuard(
          onAuthenticated: (context, authState) {
            return AuthenticatedApp(
              accountId: authState.accountId,
            );
          },
          onUnauthenticated: (context) {
            return const UnauthenticatedApp();
          },
        ),
      ),
    );
  }

  Future<void> _appInitializationActions() async {
    await Hive.initFlutter();

    /// Initialize all top-level Hive Db Providers
    final accountDbProvider = AccountDbProvider();
    final assetWalletDbProvider = AssetWalletDbProvider();
    final authTokenDbProvider = AuthTokenDbProvider();

    await accountDbProvider.init();
    await assetWalletDbProvider.init();
    await authTokenDbProvider.init();

    /// Init http client
    const apiUrl = String.fromEnvironment('API_URL');
    final publicApi = PublicHttpClient.builder(apiUrl);
    final securedApi = SecuredHttpClient.builder(
      apiUrl,
      authTokenStorage: authTokenDbProvider,
      refreshTokenService: publicApi.service<RefreshTokenService>(),
    );

    accountRepository = AccountRepository.builder(
      db: accountDbProvider,
    );
    assetWalletRepository = AssetWalletRepository.builder(
      db: assetWalletDbProvider,
    );
    authRepository = AuthRepository.builder(
      db: accountDbProvider,
      authTokenStorage: authTokenDbProvider,
      signInService: publicApi.service<SignInService>(),
      signUpService: publicApi.service<SignUpService>(),
      passwordChangeService: securedApi.service<PasswordChangeService>(),
      passwordResetService: publicApi.service<PasswordResetService>(),
    );
  }
}
