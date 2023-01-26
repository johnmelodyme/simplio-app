import 'dart:io';
import 'package:simplio_app/data/http/errors/http_error.dart';
import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/wallet_inventory_service.dart';
import 'package:simplio_app/data/models/error.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/http/apis/mappers/wallet_inventory_api_mapper.dart';

class WalletInventoryApi extends HttpApi<WalletInventoryService> {
  Future<AccountWallet> accountWalletBalance(
    AccountWallet accountWallet, {
    required String currency,
  }) async {
    try {
      final res = await service.accountWalletBalance(
        accountWallet.toAccountBalanceRequest(
          currency: currency,
        ),
      );

      final body = res.body;
      if (res.isSuccessful && body != null) {
        return accountWallet.fromAccountWalletBalanceResponse(body);
      }

      if (res.statusCode == HttpStatus.internalServerError) {
        throw InternalServerHttpError.fromObject(res.error);
      }

      throw BadRequestHttpError.fromObject(res.error);
    } on BaseError {
      rethrow;
    } catch (e) {
      throw const BadRequestHttpError(
        message: 'An error occurred while fetching account wallet balance',
      );
    }
  }

  Future<void> accountWalletTransactions(
    AccountWallet accountWallet, {
    required String currency,
    required DateTime fromDate,
    required DateTime toDate,
    required int page,
    required int pageSize,
  }) {
    throw UnimplementedError();
  }

  Future<void> networkWalletInventory(
    NetworkWallet networkWallet, {
    required String currency,
  }) {
    throw UnimplementedError();
  }
}
