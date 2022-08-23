import 'package:crypto_assets/src/system_asset_details.dart';
import 'package:crypto_assets/src/model/asset_detail.dart';

import 'asset_details.dart';

class Assets {
  const Assets._();

  static const Map<int, AssetDetail> _assets = {
    1: AssetDetails.bitcoin,
    2: AssetDetails.ethereum,
    3: AssetDetails.solana,
    4: AssetDetails.usdCoin,
    5: AssetDetails.tether,
    6: AssetDetails.binanceUSD,
    7: AssetDetails.bnb,
  };

  static const Map<int, AssetDetail> _networks = {
    0: AssetDetails.bitcoin,
    60: AssetDetails.ethereum,
    501: AssetDetails.solana,
    20000714: AssetDetails.bnbSmartChain,
  };

  static AssetDetail getAssetDetail(int assetId) {
    return _assets[assetId] ?? SystemAssetDetails.notFound;
  }

  static AssetDetail getNetworkDetail(int networkId) {
    return _networks[networkId] ?? SystemAssetDetails.notFound;
  }
}
