import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simplio_app/data/http/clients/public_http_client.dart';
import 'package:simplio_app/data/http/clients/secured_http_client.dart';
import 'package:simplio_app/data/http/services/asset_service.dart';
import 'package:simplio_app/data/http/services/balance_service.dart';
import 'package:simplio_app/data/http/services/blockchain_utils_service.dart';
import 'package:simplio_app/data/http/services/broadcast_service.dart';
import 'package:simplio_app/data/http/services/games_service.dart';
import 'package:simplio_app/data/http/services/password_change_service.dart';
import 'package:simplio_app/data/http/services/password_reset_service.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/http/services/sign_in_service.dart';
import 'package:simplio_app/data/http/services/sign_up_service.dart';
import 'package:simplio_app/data/providers/account_db_provider.dart';
import 'package:simplio_app/data/providers/auth_token_db_provider.dart';
import 'package:simplio_app/data/providers/wallet_connect_session_db_provider.dart';
import 'package:simplio_app/data/providers/wallet_db_provider.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/games_repository.dart';
import 'package:simplio_app/data/repositories/transaction_repository.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/view/authenticated_app.dart';
import 'package:simplio_app/view/routes/guards/auth_guard.dart';
import 'package:simplio_app/view/screens/splash_screen.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
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
  bool _isInitializing = true;

  late AuthRepository authRepository;
  late AccountRepository accountRepository;
  late WalletRepository walletRepository;
  late AssetRepository assetRepository;
  late WalletConnectRepository walletConnectRepository;
  late FeeRepository feeRepository;
  late TransactionRepository transactionRepository;
  late GamesRepository gamesRepository;

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return SplashScreen(
        loadingFunction: init,
        onLoaded: () => setState(() {
          _isInitializing = false;
        }),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: accountRepository),
        RepositoryProvider.value(value: walletRepository),
        RepositoryProvider.value(value: assetRepository),
        RepositoryProvider.value(value: walletConnectRepository),
        RepositoryProvider.value(value: feeRepository),
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: gamesRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc.builder(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(GotLastAuthenticated()),
        child: AuthGuard(
          onAuthenticated: (context, authState) {
            isAuthenticated = true;
            return AuthenticatedApp(
              accountId: authState.accountId,
            )..init();
          },
          onUnauthenticated: (context) {
            isAuthenticated = false;
            return const UnauthenticatedApp();
          },
        ),
      ),
    );
  }

  Future<void> init() async {
    await Hive.initFlutter();

    /// Initialize all top-level Hive Db Providers
    final authTokenDbProvider = AuthTokenDbProvider();
    final accountDbProvider = AccountDbProvider();
    final walletDbProvider = WalletDbProvider();
    final walletConnectSessionDbProvider = WalletConnectSessionDbProvider();

    await authTokenDbProvider.init();
    await accountDbProvider.init();
    await walletDbProvider.init();
    await walletConnectSessionDbProvider.init();

    /// Init http client
    const apiUrl = String.fromEnvironment('API_URL');
    final publicApi = PublicHttpClient.builder(apiUrl);
    final securedApi = SecuredHttpClient.builder(
      apiUrl,
      authTokenStorage: authTokenDbProvider,
      refreshTokenService: publicApi.service<RefreshTokenService>(),
    );

    // Initialize repositories
    authRepository = AuthRepository.builder(
      accountDb: accountDbProvider,
      authTokenStorage: authTokenDbProvider,
      signInService: publicApi.service<SignInService>(),
      signUpService: publicApi.service<SignUpService>(),
      passwordChangeService: securedApi.service<PasswordChangeService>(),
      passwordResetService: publicApi.service<PasswordResetService>(),
    );
    accountRepository = AccountRepository.builder(
      accountDb: accountDbProvider,
    );
    walletRepository = WalletRepository(
      walletDb: walletDbProvider,
      blockchainUtilsService: securedApi.service<BlockchainUtilsService>(),
      broadcastService: securedApi.service<BroadcastService>(),
      balanceService: securedApi.service<BalanceService>(),
    );
    assetRepository = AssetRepository.builder(
      assetService: securedApi.service<AssetService>(),
    );
    walletConnectRepository = WalletConnectRepository(
      walletConnectSessionDb: walletConnectSessionDbProvider,
    );
    feeRepository = FeeRepository.builder(
      assetService: securedApi.service<AssetService>(),
    );

    transactionRepository = TransactionRepository();

    gamesRepository = GamesRepository.builder(
      gamesService: securedApi.service<GamesService>(),
    );
  }
}
