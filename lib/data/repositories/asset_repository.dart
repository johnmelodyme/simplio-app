import 'package:simplio_app/data/http/apis/asset_api.dart';
import 'package:simplio_app/data/providers/helpers/memory_cache_provider.dart';
import 'package:sio_core_light/sio_core_light.dart' as sio;

const _cacheLifetimeInSeconds = 1800;

class AssetRepository {
  static int assetId({required int networkId}) {
    return sio.Networks.assetId(networkId: networkId);
  }

  static int chainId({required int networkId}) {
    return sio.EthNetworks.chainId(networkId: networkId);
  }

  static int networkId({required int chainId}) {
    return sio.EthNetworks.networkId(chainId: chainId);
  }

  final AssetApi _assetApi;

  final MemoryCacheProvider<List<FiatAssetData>> _fiatDataCache;

  AssetRepository._(
    this._assetApi,
    this._fiatDataCache,
  );

  AssetRepository({
    required AssetApi assetApi,
  }) : this._(
          assetApi,
          MemoryCacheProvider.builder(
            lifetimeInSeconds: _cacheLifetimeInSeconds,
            initialData: const [],
          ),
        );

  Future<List<FiatAssetData>> loadFiatAssets({
    bool readCache = true,
  }) async {
    if (readCache && _fiatDataCache.isValid) return _fiatDataCache.read();

    final fiatAssets = await _assetApi.loadFiatAssets();
    _fiatDataCache.write(fiatAssets);
    return fiatAssets;
  }
}

// TODO - verify why it was not refactored and removed?
class CryptoAssetData {
  final int assetId;
  final String name;
  final String ticker;
  final double price;
  final Set<NetworkData> networks;

  const CryptoAssetData({
    required this.assetId,
    required this.name,
    required this.ticker,
    required this.price,
    required this.networks,
  });
}

class NetworkData {
  final int networkId;
  final int assetId;
  final String networkTicker;

  const NetworkData({
    required this.networkId,
    required this.assetId,
    required this.networkTicker,
  });
}

class FiatAssetData {
  final String assetId;
  final String name;
  final String ticker;

  const FiatAssetData({
    required this.assetId,
    required this.name,
    required this.ticker,
  });
}
