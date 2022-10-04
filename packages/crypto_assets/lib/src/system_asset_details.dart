import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';

class SystemAssetDetails {
  const SystemAssetDetails._();

  static const AssetDetail notFound = AssetDetail(
    name: '',
    ticker: '',
    style: AssetStyle(
      icon: Icons.question_mark_outlined,
      primaryColor: Colors.black12,
      foregroundColor: Colors.white,
    ),
  );
}
