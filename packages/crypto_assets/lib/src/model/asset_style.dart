import 'package:flutter/material.dart';

@immutable
class AssetStyle {
  final Color primaryColor;
  final Color foregroundColor;
  final Widget icon;

  const AssetStyle({
    required this.icon,
    required this.primaryColor,
    required this.foregroundColor,
  });
}
