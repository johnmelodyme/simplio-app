import 'package:crypto_assets/crypto_assets.dart';
import 'package:crypto_assets/src/model/asset_preset.dart';

abstract class SystemAssetPreset extends AssetPreset {
  const SystemAssetPreset();
}

class AssetPresetNotFound extends SystemAssetPreset {
  const AssetPresetNotFound();
}

class SystemAssetPresets {
  const SystemAssetPresets._();

  static const SystemAssetPreset notFound = AssetPresetNotFound();
}
