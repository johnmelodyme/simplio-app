import 'package:flutter/foundation.dart';
import 'package:crypto_assets/src/model/asset_style.dart';

@immutable
class AssetDetail {
  final String name;
  final String ticker;
  final AssetStyle style;

  const AssetDetail({
    required this.name,
    required this.ticker,
    required this.style,
  });
}
