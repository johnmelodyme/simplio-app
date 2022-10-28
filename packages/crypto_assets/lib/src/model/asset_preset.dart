import 'package:flutter/foundation.dart';

@immutable
class AssetPreset {
  final String? contractAddress;
  final int decimalPlaces;

  const AssetPreset({
    this.contractAddress,
    this.decimalPlaces = 2,
  });
}
