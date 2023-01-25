import 'dart:io';
import 'package:simplio_app/data/http/errors/bad_request_http_error.dart';
import 'package:simplio_app/data/http/errors/internal_server_http_error.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/providers/helpers/memory_cache_provider.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

const _cacheLifetimeInSeconds = 1800;

class SwapRepository {
  final SwapService _swapService;

  final MemoryCacheProvider<List<SwapRoute>> _swapRoutesCache;

  SwapRepository._(
    this._swapService,
    this._swapRoutesCache,
  );

  SwapRepository.builder({
    required SwapService swapService,
  }) : this._(
          swapService,
          MemoryCacheProvider<List<SwapRoute>>.builder(
            lifetimeInSeconds: _cacheLifetimeInSeconds,
            initialData: const [],
          ),
        );

  void clearSwapRoutesCache() {
    _swapRoutesCache.clear();
  }

  Future<List<SwapRoute>> loadRoutes([
    bool readCache = true,
  ]) async {
    if (readCache && _swapRoutesCache.isValid) return _swapRoutesCache.read();

    final res = await _swapService.getAvailableRoutes();
    final body = res.body;

    if (res.isSuccessful && body != null) {
      final swapRoutes = body.map(SwapRoute.fromSwapRouteResponse).toList();
      _swapRoutesCache.write(swapRoutes);
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
    final res = await _swapService.getSwapParameters(
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

  Future<bool> startSwap({
    required String sourceTxHash,
    required String targetAddress,
    required String refundAddress,
    required BigInt userAgreedAmount,
    required int sourceAssetId,
    required int sourceNetworkId,
    required int targetAssetId,
    required int targetNetworkId,
    // TODO: later take this from UI. for now set it to 1
    required int slippage,
  }) async {
    return false;
    // TODO - refactor!
    // final SingleSwapBody body = SingleSwapBody(
    //   sourceTxId: sourceTxHash,
    //   targetAddress: targetAddress,
    //   refundAddress: refundAddress,
    //   userAgreedAmount: userAgreedAmount,
    //   sourceAsset: CryptoAsset(
    //     assetId: sourceAssetId,
    //     networkId: sourceNetworkId,
    //   ),
    //   targetAsset: CryptoAsset(
    //     assetId: targetAssetId,
    //     networkId: targetNetworkId,
    //   ),
    //   slippage: slippage,
    // );

    // final res = await _swapService.startSingleSwap(body);

    // final startSwapResult = res.body;
    // if (res.isSuccessful && startSwapResult != null) return startSwapResult;

    // if (res.statusCode == HttpStatus.badRequest) {
    //   throw BadRequestHttpError.fromObject(res.error);
    // }

    // throw Exception('Could not start single swap: ${res.error}');
  }
}

// TODO - remove all unceserary field.
// TODO - add a timestamp to the response that can repeat the request if it is too old.
class SwapConversion {
  final BigDecimal withdrawalAmount;
  final BigDecimal minAmount;
  final SwapParametersResponse response;

  SwapConversion({
    required this.withdrawalAmount,
    required this.minAmount,
    required this.response,
  });
}

class SwapRoute {
  final SwapAsset sourceAsset;
  final SwapAsset targetAsset;
  final String sourceDepositAddress;

  const SwapRoute({
    required this.sourceAsset,
    required this.targetAsset,
    required this.sourceDepositAddress,
  });

  SwapRoute.fromSwapRouteResponse(SwapRouteResponse r)
      : this(
          sourceAsset: SwapAsset.fromCryptoAsset(r.sourceAsset),
          targetAsset: SwapAsset.fromCryptoAsset(r.targetAsset),
          sourceDepositAddress: r.sourceDepositAddress,
        );
}

class SwapAsset {
  final int assetId;
  final int networkId;
  final BigDecimal price;

  const SwapAsset({
    required this.assetId,
    required this.networkId,
    required this.price,
  });

  SwapAsset.fromCryptoAsset(CryptoAsset a)
      : this(
          assetId: a.assetId,
          networkId: a.networkId,
          price: BigDecimal.fromDouble(a.price),
        );
}
