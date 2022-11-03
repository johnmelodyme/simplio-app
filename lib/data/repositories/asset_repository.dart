import 'package:simplio_app/data/http/services/asset_service.dart';
import 'package:simplio_app/data/providers/memory_cache_provider.dart';
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

  final AssetService _assetService;

  final MemoryCacheProvider<List<FiatAssetData>> _fiatDataCache;

  AssetRepository._(
    this._assetService,
    this._fiatDataCache,
  );

  AssetRepository.builder({
    required AssetService assetService,
  }) : this._(
          assetService,
          MemoryCacheProvider.builder(
            lifetimeInSeconds: _cacheLifetimeInSeconds,
            initialData: const [],
          ),
        );

  Future<List<FiatAssetData>> loadFiatAssets({
    bool readCache = true,
  }) async {
    if (readCache && _fiatDataCache.isValid) return _fiatDataCache.read();

    final response = await _assetService.fiat();
    final body = response.body;

    if (response.isSuccessful && body != null) {
      final fiatAssets = _makeFiatAssetData(body);
      _fiatDataCache.write(fiatAssets);
      return fiatAssets;
    }

    throw Exception("Could not load 'fiat' assets");
  }

  List<FiatAssetData> _makeFiatAssetData(List<FiatAssetResponse> response) {
    final map = response.fold<Map<String, FiatAssetData>>({}, (acc, curr) {
      return acc
        ..addAll({
          curr.assetId: FiatAssetData(
            assetId: curr.assetId,
            name: curr.name,
            ticker: curr.ticker,
          ),
        });
    });

    return map.values.toList();
  }
}

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
