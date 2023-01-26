import 'dart:io';
import 'package:simplio_app/data/http/errors/http_error.dart';
import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

class SwapApi extends HttpApi<SwapService> {
  Future<List<SwapRoute>> loadRoutes([
    bool readCache = true,
  ]) async {
    final res = await service.getAvailableRoutes();
    final body = res.body;

    if (res.isSuccessful && body != null) {
      final swapRoutes = body.map(SwapRoute.fromSwapRouteResponse).toList();
      return swapRoutes;
    }

    if (res.statusCode == HttpStatus.badRequest) {
      throw BadRequestHttpError.fromObject(res.error);
    }

    if (res.statusCode == HttpStatus.internalServerError) {
      throw InternalServerHttpError.fromObject(res.error);
    }

    throw Exception('Could not load swap routes: ${res.error}');
  }

  Future<SwapConversion> convert({
    required BigDecimal sourceAmount,
    required int sourceAssetId,
    required int sourceNetworkId,
    required int sourceAssetPrecision,
    required int targetAssetId,
    required int targetNetworkId,
  }) async {
    final res = await service.getSwapParameters(
      sourceAmount: sourceAmount.toBigInt().toString(),
      sourceAssetId: sourceAssetId.toString(),
      sourceNetworkId: sourceNetworkId.toString(),
      targetAssetId: targetAssetId.toString(),
      targetNetworkId: targetNetworkId.toString(),
    );

    final swapData = res.body;
    if (res.isSuccessful && swapData != null) {
      return SwapConversion(
        withdrawalAmount: BigDecimal.fromBigInt(
          swapData.targetGuaranteedWithdrawalAmount,
          precision: sourceAssetPrecision,
        ),
        minAmount: BigDecimal.fromBigInt(
          swapData.sourceMinDepositAmount,
          precision: sourceAssetPrecision,
        ),
        response: swapData,
      );
    }

    if (res.statusCode == HttpStatus.badRequest) {
      throw BadRequestHttpError.fromObject(res.error);
    }

    if (res.statusCode == HttpStatus.internalServerError) {
      throw InternalServerHttpError.fromObject(res.error);
    }

    throw Exception('Could not load active swap parameters: ${res.error}');
  }
}
