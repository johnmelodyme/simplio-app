import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';

abstract class SystemAssetDetail extends AssetDetail {
  const SystemAssetDetail({required super.style});
}

class AssetDetailNotFound extends SystemAssetDetail {
  const AssetDetailNotFound({required super.style});
}

class SystemAssetDetails {
  SystemAssetDetails._();

  static const SystemAssetDetail notFound = AssetDetailNotFound(
    style: AssetStyle(
      icon: Icon(Icons.question_mark_outlined),
      primaryColor: Colors.black12,
      foregroundColor: Colors.white,
    ),
  );
}
