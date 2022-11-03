import 'package:chopper/chopper.dart';
import 'package:simplio_app/data/http/authenticators/refresh_token_authenticator.dart';
import 'package:simplio_app/data/http/clients/http_client.dart';
import 'package:simplio_app/data/http/converters/json_serializable_converter.dart';
import 'package:simplio_app/data/http/interceptors/api_key_interceptor.dart';
import 'package:simplio_app/data/http/interceptors/authorize_interceptor.dart';
import 'package:simplio_app/data/http/services/account_service.dart';
import 'package:simplio_app/data/http/services/asset_service.dart';
import 'package:simplio_app/data/http/services/balance_service.dart';
import 'package:simplio_app/data/http/services/blockchain_utils_service.dart';
import 'package:simplio_app/data/http/services/broadcast_service.dart';
import 'package:simplio_app/data/http/services/buy_service.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/http/services/inventory_service.dart';
import 'package:simplio_app/data/http/services/password_change_service.dart';
import 'package:simplio_app/data/http/services/refresh_token_service.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/http/services/transaction_history_service.dart';
import 'package:simplio_app/data/model/auth_token.dart';
import 'package:simplio_app/data/providers/storage_provider.dart';

class SecuredHttpClient extends HttpClient {
  @override
  final ChopperClient client;

  SecuredHttpClient._(this.client);

  SecuredHttpClient.builder(
    String url, {
    required StorageProvider<AuthToken> authTokenStorage,
    required RefreshTokenService refreshTokenService,
  }) : this._(
          ChopperClient(
            baseUrl: url,
            converter: JsonSerializableConverter({
              ...AssetService.converter(),
              ...BalanceService.converter(),
              ...BlockchainUtilsService.converter(),
              ...BroadcastService.converter(),
              ...PasswordChangeService.converter(),
              ...TransactionHistoryService.converter(),
              ...MarketplaceService.converter(),
              ...AccountService.converter(),
              ...BuyService.converter(),
              ...InventoryService.converter(),
              ...SwapService.converter(),
              ...BuyService.converter(),
            }),
            authenticator: RefreshTokenAuthenticator(
              authTokenStorage: authTokenStorage,
              refreshTokenService: refreshTokenService,
            ),
            interceptors: [
              ApiKeyInterceptor(),
              AuthorizeInterceptor(authTokenStorage: authTokenStorage),
            ],
            services: [
              AssetService.create(),
              BalanceService.create(),
              BlockchainUtilsService.create(),
              BroadcastService.create(),
              PasswordChangeService.create(),
              TransactionHistoryService.create(),
              MarketplaceService.create(),
              AccountService.create(),
              BuyService.create(),
              InventoryService.create(),
              SwapService.create(),
              BuyService.create(),
            ],
          ),
        );
}
