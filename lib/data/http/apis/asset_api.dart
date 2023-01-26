import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/asset_service.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';

class AssetApi extends HttpApi<AssetService> {
  Future<List<FiatAssetData>> loadFiatAssets({
    bool readCache = true,
  }) async {
    final response = await service.fiat();
    final body = response.body;

    if (response.isSuccessful && body != null) {
      final fiatAssets = _makeFiatAssetData(body);
      return fiatAssets;
    }

    throw Exception("Could not load 'fiat' assets");
  }

  Future<CryptoAssetResponse> getCryptoFees(
    int assetId,
    int networkId,
  ) async {
    final res = await service.crypto(
      selectedAssets: [assetId.toString()],
      selectedNetworks: [networkId.toString()],
    );

    final body = res.body;
    if (res.isSuccessful && body?.isNotEmpty == true) return body!.first;

    throw Exception(res.error);
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
