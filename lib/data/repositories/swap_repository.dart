import 'dart:io';

import 'package:simplio_app/data/http/errors/bad_request_http_error.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/providers/memory_cache_provider.dart';

const _cacheLifetimeInSeconds = 1800;

class SwapRepository {
  final SwapService _swapService;

  final MemoryCacheProvider<List<SwapRouteResponse>> _swapRoutesCache;

  SwapRepository._(
    this._swapService,
    this._swapRoutesCache,
  );

  SwapRepository.builder({
    required SwapService swapService,
  }) : this._(
          swapService,
          MemoryCacheProvider<List<SwapRouteResponse>>.builder(
            lifetimeInSeconds: _cacheLifetimeInSeconds,
            initialData: const [],
          ),
        );

  void clearSwapRoutesCache() {
    _swapRoutesCache.clear();
  }

  Future<List<SwapRouteResponse>> loadSwapRoutes([
    bool readCache = true,
  ]) async {
    if (readCache && _swapRoutesCache.isValid) return _swapRoutesCache.read();

    final res = await _swapService.getAvailableRoutes();
    final swapRoutes = res.body;

    if (res.isSuccessful && swapRoutes != null) {
      _swapRoutesCache.write(swapRoutes);
      return swapRoutes;
    }

    if (res.statusCode == HttpStatus.badRequest) {
      throw BadRequestHttpError.fromObject(res.error);
    }

    throw Exception('Could not load swap routes: ${res.error}');
  }

  Future<SwapParametersResponse> getSwapData({
    required BigInt sourceAmount,
    required int sourceAssetId,
    required int sourceNetworkId,
    required int targetAssetId,
    required int targetNetworkId,
  }) async {
    final res = await _swapService.getSwapParameters(
      sourceAmount: sourceAmount.toString(),
      sourceAssetId: sourceAssetId.toString(),
      sourceNetworkId: sourceNetworkId.toString(),
      targetAssetId: targetAssetId.toString(),
      targetNetworkId: targetNetworkId.toString(),
    );

    final swapData = res.body;
    if (res.isSuccessful && swapData != null) return swapData;

    if (res.statusCode == HttpStatus.badRequest) {
      throw BadRequestHttpError.fromObject(res.error);
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
    final SingleSwapBody body = SingleSwapBody(
      sourceTxId: sourceTxHash,
      targetAddress: targetAddress,
      refundAddress: refundAddress,
      userAgreedAmount: userAgreedAmount,
      sourceAsset: CryptoAsset(
        assetId: sourceAssetId,
        networkId: sourceNetworkId,
      ),
      targetAsset: CryptoAsset(
        assetId: targetAssetId,
        networkId: targetNetworkId,
      ),
      slippage: slippage,
    );

    final res = await _swapService.startSingleSwap(body);

    final startSwapResult = res.body;
    if (res.isSuccessful && startSwapResult != null) return startSwapResult;

    if (res.statusCode == HttpStatus.badRequest) {
      throw BadRequestHttpError.fromObject(res.error);
    }

    throw Exception('Could not start single swap: ${res.error}');
  }
}
