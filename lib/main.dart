import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simplio_app/data/http/apis/account_api.dart';
import 'package:simplio_app/data/http/apis/asset_api.dart';
import 'package:simplio_app/data/http/apis/blockchain_api.dart';
import 'package:simplio_app/data/http/apis/broadcast_api.dart';
import 'package:simplio_app/data/http/apis/buy_api.dart';
import 'package:simplio_app/data/http/apis/marketplace_api.dart';
import 'package:simplio_app/data/http/apis/password_change_api.dart';
import 'package:simplio_app/data/http/apis/password_reset_api.dart';
import 'package:simplio_app/data/http/apis/refresh_token_api.dart';
import 'package:simplio_app/data/http/apis/sign_in_api.dart';
import 'package:simplio_app/data/http/apis/sign_up_api.dart';
import 'package:simplio_app/data/http/apis/swap_api.dart';
import 'package:simplio_app/data/http/apis/transaction_history_api.dart';
import 'package:simplio_app/data/http/apis/wallet_inventory_api.dart';
import 'package:simplio_app/data/http/authenticators/refresh_token_authenticator.dart';
import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';
import 'package:simplio_app/data/http/interceptors/authorize_interceptor.dart';
import 'package:simplio_app/data/http/services/account_service.dart';
import 'package:simplio_app/data/http/services/asset_service.dart';
import 'package:simplio_app/data/http/services/blockchain_utils_service.dart';
import 'package:simplio_app/data/http/services/broadcast_service.dart';
import 'package:simplio_app/data/http/services/buy_service.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/http/services/password_change_service.dart';
import 'package:simplio_app/data/http/services/password_reset_service.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/http/services/sign_in_service.dart';
import 'package:simplio_app/data/http/services/sign_up_service.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/http/services/transaction_history_service.dart';
import 'package:simplio_app/data/http/services/wallet_inventory_service.dart';
import 'package:simplio_app/data/providers/account_db_provider.dart';
import 'package:simplio_app/data/providers/auth_token_db_provider.dart';
import 'package:simplio_app/data/providers/wallet_connect_session_db_provider.dart';
import 'package:simplio_app/data/providers/wallet_db_provider.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/data/repositories/buy_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/hd_wallet_repository.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/data/repositories/transaction_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/view/authenticated_app.dart';
import 'package:simplio_app/view/guards/auth_guard.dart';
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
  late BuyRepository buyRepository;
  late TransactionRepository transactionRepository;
  late MarketplaceRepository marketplaceRepository;
  late SwapRepository swapRepository;
  late UserRepository userRepository;

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
        RepositoryProvider.value(value: marketplaceRepository),
        RepositoryProvider.value(value: buyRepository),
        RepositoryProvider.value(value: swapRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc.builder(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(GotLastAuthenticated()),
        child: AuthGuard(
          onAuthenticated: (context, account) {
            isAuthenticated = true;
            return AuthenticatedApp(
              account: account,
            )..init(context);
          },
          onUnauthenticated: (context) {
            isAuthenticated = false;
            return const UnauthenticatedApp()..init(context);
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

    final publicApi = HttpClient(
      url: apiUrl,
      converter: JsonSerializableConverter([
        SignInService.converter(),
        SignUpService.converter(),
        RefreshTokenService.converter(),
        PasswordResetService.converter(),
      ]),
      services: [
        SignInService.create(),
        SignUpService.create(),
        RefreshTokenService.create(),
        PasswordResetService.create(),
      ],
    );

    publicApi.registerApi(RefreshTokenApi());
    publicApi.registerApi(SignInApi());
    publicApi.registerApi(SignUpApi());
    publicApi.registerApi(PasswordResetApi());

    final authorizedApi = HttpClient(
      url: apiUrl,
      converter: JsonSerializableConverter([
        AssetService.converter(),
        WalletInventoryService.converter(),
        BlockchainUtilsService.converter(),
        BroadcastService.converter(),
        PasswordChangeService.converter(),
        TransactionHistoryService.converter(),
        MarketplaceService.converter(),
        AccountService.converter(),
        BuyService.converter(),
        SwapService.converter(),
        BuyService.converter(),
      ]),
      authenticator: RefreshTokenAuthenticator(
        authTokenStorage: authTokenDbProvider,
        refreshTokenApi: publicApi.api<RefreshTokenApi>(),
      ),
      interceptors: [
        AuthorizeInterceptor(
          authTokenStorage: authTokenDbProvider,
        ),
      ],
      services: [
        AssetService.create(),
        WalletInventoryService.create(),
        BlockchainUtilsService.create(),
        BroadcastService.create(),
        PasswordChangeService.create(),
        TransactionHistoryService.create(),
        MarketplaceService.create(),
        AccountService.create(),
        BuyService.create(),
        SwapService.create(),
      ],
    );

    authorizedApi.registerApi(AssetApi());
    authorizedApi.registerApi(WalletInventoryApi());
    authorizedApi.registerApi(BlockchainApi());
    authorizedApi.registerApi(BroadcastApi());
    authorizedApi.registerApi(PasswordChangeApi());
    authorizedApi.registerApi(TransactionHistoryApi());
    authorizedApi.registerApi(MarketplaceApi());
    authorizedApi.registerApi(AccountApi());
    authorizedApi.registerApi(BuyApi());
    authorizedApi.registerApi(SwapApi());

    // Initialize repositories
    authRepository = AuthRepository(
      accountDb: accountDbProvider,
      authTokenStorage: authTokenDbProvider,
      signInApi: publicApi.api<SignInApi>(),
      signUpApi: publicApi.api<SignUpApi>(),
      passwordChangeApi: authorizedApi.api<PasswordChangeApi>(),
      passwordResetApi: publicApi.api<PasswordResetApi>(),
    );
    accountRepository = AccountRepository(
      accountDb: accountDbProvider,
    );
    walletRepository = HDWalletRepository(
      walletDb: walletDbProvider,
      blockchainApi: authorizedApi.api<BlockchainApi>(),
      broadcastApi: authorizedApi.api<BroadcastApi>(),
      walletInventoryApi: authorizedApi.api<WalletInventoryApi>(),
    );
    assetRepository = AssetRepository(
      assetApi: authorizedApi.api<AssetApi>(),
    );
    walletConnectRepository = WalletConnectRepository(
      walletConnectSessionDb: walletConnectSessionDbProvider,
    );
    feeRepository = FeeRepository(
      assetApi: authorizedApi.api<AssetApi>(),
    );
    buyRepository = BuyRepository(
      buyApi: authorizedApi.api<BuyApi>(),
    );
    transactionRepository = TransactionRepository();
    marketplaceRepository = MarketplaceRepository(
      marketplaceApi: authorizedApi.api<MarketplaceApi>(),
    );
    swapRepository = SwapRepository(
      swapApi: authorizedApi.api<SwapApi>(),
    );
    userRepository = UserRepository(
      accountApi: authorizedApi.api<AccountApi>(),
    );
  }
}
