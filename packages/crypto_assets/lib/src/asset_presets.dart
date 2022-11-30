import 'package:crypto_assets/src/asset_identifiers.dart';
import 'package:crypto_assets/src/model/asset_preset.dart';
import 'package:crypto_assets/src/model/helpers/types.dart';

typedef NetworkPresetMap = Map<AssetId, AssetPreset>;

class AssetPresets {
  const AssetPresets._();

  static NetworkPresetMap bitcoin = {
    AssetIds.bitcoin.id: const AssetPreset(
      decimalPlaces: 8,
    ),
  };

  static NetworkPresetMap ethereum = {};

  static NetworkPresetMap solana = {
    AssetIds.solana.id: const AssetPreset(
      decimalPlaces: 9,
    ),
    AssetIds.tether.id: const AssetPreset(
      decimalPlaces: 6,
      contractAddress: 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB',
    ),
  };

  static NetworkPresetMap bnbSmartChain = {
    AssetIds.usdCoin.id: const AssetPreset(
        decimalPlaces: 18,
        contractAddress: '0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d'),
    AssetIds.tether.id: const AssetPreset(
      decimalPlaces: 18,
      contractAddress: '0x55d398326f99059ff775485246999027b3197955',
    ),
    AssetIds.binanceUSD.id: const AssetPreset(
      decimalPlaces: 18,
      contractAddress: '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
    ),
    AssetIds.bnb.id: const AssetPreset(
      decimalPlaces: 18,
    ),
    AssetIds.dai.id: const AssetPreset(
      decimalPlaces: 18,
      contractAddress: '0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3',
    ),
    AssetIds.tinyCoin.id: const AssetPreset(
      decimalPlaces: 18,
      contractAddress: '0x05aD6E30A855BE07AfA57e08a4f30d00810a402e',
    ),
    AssetIds.mobox.id: const AssetPreset(
      decimalPlaces: 18,
      contractAddress: '0x3203c9E46cA618C8C1cE5dC67e7e9D75f5da2377',
    )
  };
}
