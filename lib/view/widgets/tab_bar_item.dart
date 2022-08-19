import 'package:flutter/material.dart';

enum TabItemType {
  button,
  spacer,
}

typedef TabBarItemCallback = void Function(BuildContext context, Key key);

class TabBarItem {
  final Key? key;
  final TabItemType tabBarItemType;
  final TabBarItemCallback? onTap;
  final IconData? icon;
  final IconData? activeIcon;
  final String? label;

  TabBarItem({
    required this.tabBarItemType,
    this.key,
    this.onTap,
    this.icon,
    this.activeIcon,
    this.label,
  }) : assert(
          tabBarItemType == TabItemType.button ? key != null : true,
          "Key must be provided for TabBarItem of type $tabBarItemType",
        );
}
