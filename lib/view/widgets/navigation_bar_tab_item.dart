import 'package:flutter/material.dart';

class NavigationBarTabItem {
  NavigationBarTabItem({
    required this.label,
    required this.bottomSlivers,
    this.topSlivers,
    this.iconData,
    this.iconColor,
    this.onRefresh,
  });

  final String label;
  final List<Widget>? topSlivers;
  final List<Widget> bottomSlivers;
  final IconData? iconData;
  final Color? iconColor;
  final Future<void> Function()? onRefresh;
}
