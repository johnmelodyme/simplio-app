import 'package:simplio_app/data/http/services/asset_service.dart';
import 'package:simplio_app/data/providers/memory_cache_provider.dart';

const _cacheLifetimeInSeconds = 10;

class AssetRepository {
  final AssetService _assetService;

  final MemoryCacheProvider<List<CryptoAssetData>> _cryptoDataCache;
  final MemoryCacheProvider<List<FiatAssetData>> _fiatDataCache;

  AssetRepository._(
    this._assetService,
    this._cryptoDataCache,
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
          MemoryCacheProvider.builder(
            lifetimeInSeconds: _cacheLifetimeInSeconds,
            initialData: const [],
          ),
        );

  Future<List<CryptoAssetData>> loadCryptoAssets({bool cache = true}) async {
    if (cache && _cryptoDataCache.isValid) return _cryptoDataCache.read();

    final response = await _assetService.system(
      isCrypto: true,
      isActive: true,
    );

    final body = response.body;

    if (response.isSuccessful && body != null) {
      final cryptoAssets = _makeCryptoAssetData(body);
      _cryptoDataCache.write(cryptoAssets);
      return cryptoAssets;
    }

    throw Exception("Could not load 'crypto' assets");
  }

  Future<List<FiatAssetData>> loadFiatAssets({bool cache = true}) async {
    if (cache && _fiatDataCache.isValid) return _fiatDataCache.read();

    final response = await _assetService.system(
      isCrypto: false,
      isActive: true,
    );

    final body = response.body;

    if (response.isSuccessful && body != null) {
      final fiatAssets = _makeFiatAssetData(body);
      _fiatDataCache.write(fiatAssets);
      return fiatAssets;
    }

    throw Exception("Could not load 'fiat' assets");
  }

  List<CryptoAssetData> _makeCryptoAssetData(List<AssetResponse> response) {
    final map = response.fold<Map<String, CryptoAssetData>>({}, (acc, curr) {
      final data = acc[curr.assetId];
      if (data != null) {
        data.networks.add(NetworkData(
          networkId: int.parse(curr.networkId),
          assetId: int.parse(curr.assetId),
          networkTicker: curr.networkSymbol ?? '',
          contractAddress: curr.contractAddress,
        ));
        return acc;
      }

      return acc
        ..addAll({
          curr.assetId: CryptoAssetData(
              assetId: int.parse(curr.assetId),
              name: curr.name,
              ticker: curr.symbol,
              networks: <NetworkData>{
                NetworkData(
                  networkId: int.parse(curr.networkId),
                  assetId: int.parse(curr.assetId),
                  networkTicker: curr.networkSymbol ?? '',
                  contractAddress: curr.contractAddress,
                ),
              })
        });
    });

    return map.values.toList();
  }

  List<FiatAssetData> _makeFiatAssetData(List<AssetResponse> response) {
    final map = response.fold<Map<String, FiatAssetData>>({}, (acc, curr) {
      return acc
        ..addAll({
          curr.assetId: FiatAssetData(
            assetId: int.parse(curr.assetId),
            name: curr.name,
            ticker: curr.symbol,
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
  final Set<NetworkData> networks;

  const CryptoAssetData({
    required this.assetId,
    required this.name,
    required this.ticker,
    required this.networks,
  });
}

class NetworkData {
  final int networkId;
  final int assetId;
  final String networkTicker;
  final String? contractAddress;

  const NetworkData({
    required this.networkId,
    required this.assetId,
    required this.networkTicker,
    this.contractAddress,
  });
}

class FiatAssetData {
  final int assetId;
  final String name;
  final String ticker;

  const FiatAssetData({
    required this.assetId,
    required this.name,
    required this.ticker,
  });
}
