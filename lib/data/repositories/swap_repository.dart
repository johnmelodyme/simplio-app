import 'package:simplio_app/data/http/apis/swap_api.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/providers/helpers/memory_cache_provider.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

const _cacheLifetimeInSeconds = 1800;

class SwapRepository {
  final SwapApi _swapApi;

  final MemoryCacheProvider<List<SwapRoute>> _swapRoutesCache;

  SwapRepository._(
    this._swapApi,
    this._swapRoutesCache,
  );

  SwapRepository({
    required SwapApi swapApi,
  }) : this._(
          swapApi,
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
    final routes = await _swapApi.loadRoutes();
    _swapRoutesCache.write(routes);
    return routes;
  }

  Future<SwapConversion> convert({
    required BigDecimal sourceAmount,
    required int sourceAssetId,
    required int sourceNetworkId,
    required int sourceAssetPrecision,
    required int targetAssetId,
    required int targetNetworkId,
  }) {
    return _swapApi.convert(
      sourceAmount: sourceAmount,
      sourceAssetId: sourceAssetId,
      sourceNetworkId: sourceNetworkId,
      sourceAssetPrecision: sourceAssetPrecision,
      targetAssetId: targetAssetId,
      targetNetworkId: targetNetworkId,
    );
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
