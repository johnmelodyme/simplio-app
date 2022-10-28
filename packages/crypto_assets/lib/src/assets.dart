import 'package:crypto_assets/src/asset_identifiers.dart';
import 'package:crypto_assets/src/asset_presets.dart';
import 'package:crypto_assets/src/model/asset_detail.dart';
import 'package:crypto_assets/src/model/asset_preset.dart';
import 'package:crypto_assets/src/model/helpers/types.dart';
import 'package:crypto_assets/src/network_identifiers.dart';
import 'package:crypto_assets/src/system_asset_details.dart';
import 'package:crypto_assets/src/system_asset_presets.dart';

import 'asset_details.dart';

class Assets {
  const Assets._();

  static final Map<AssetId, AssetDetail> _assets = {
    AssetIds.bitcoin.id: AssetDetails.bitcoin,
    AssetIds.ethereum.id: AssetDetails.ethereum,
    AssetIds.solana.id: AssetDetails.solana,
    AssetIds.usdCoin.id: AssetDetails.usdCoin,
    AssetIds.tether.id: AssetDetails.tether,
    AssetIds.binanceUSD.id: AssetDetails.binanceUSD,
    AssetIds.bnb.id: AssetDetails.bnb,
    AssetIds.dai.id: AssetDetails.dai,
  };

  static final Map<NetworkId, AssetDetail> _networks = {
    NetworkIds.bitcoin.id: AssetDetails.bitcoin,
    NetworkIds.ethereum.id: AssetDetails.ethereum,
    NetworkIds.solana.id: AssetDetails.solana,
    NetworkIds.bnbSmartChain.id: AssetDetails.bnbSmartChain,
  };

  static final Map<NetworkId, NetworkPresetMap> _presets = {
    NetworkIds.bitcoin.id: AssetPresets.bitcoin,
    NetworkIds.ethereum.id: AssetPresets.ethereum,
    NetworkIds.solana.id: AssetPresets.solana,
    NetworkIds.bnbSmartChain.id: AssetPresets.bnbSmartChain,
  };

  static AssetDetail getAssetDetail(AssetId assetId) {
    return _assets[assetId] ?? SystemAssetDetails.notFound;
  }

  static AssetDetail getNetworkDetail(NetworkId networkId) {
    return _networks[networkId] ?? SystemAssetDetails.notFound;
  }

  static AssetPreset getAssetPreset({
    required AssetId assetId,
    required NetworkId networkId,
  }) {
    final networkPresets = _presets[networkId];
    if (networkPresets == null) return SystemAssetPresets.notFound;
    return networkPresets[assetId] ?? SystemAssetPresets.notFound;
  }
}
