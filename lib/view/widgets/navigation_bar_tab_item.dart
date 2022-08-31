import 'package:flutter/material.dart';

class NavigationBarTabItem {
  NavigationBarTabItem({
    required this.label,
    required this.pageSlivers,
    this.iconData,
    this.iconColor,
    this.onRefresh,
  });

  final String label;
  final List<Widget> pageSlivers;
  final IconData? iconData;
  final Color? iconColor;
  final Future<void> Function()? onRefresh;
}
