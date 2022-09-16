import 'package:flutter/material.dart';

class ApplicationSettings extends RouteSettings {
  final TabBarRouteSettings? tabBar;

  @override
  ApplicationArguments get arguments => ApplicationArguments(
        tabBar: tabBar,
      );

  const ApplicationSettings({
    this.tabBar,
  });

  const ApplicationSettings.hiddenTabBar({
    this.tabBar = const TabBarRouteSettings(isVisible: false),
  });
}

class ApplicationArguments {
  final TabBarRouteSettings? tabBar;

  ApplicationArguments({
    this.tabBar,
  });
}

class TabBarRouteSettings {
  final Key? selectedKey;
  final bool isVisible;

  const TabBarRouteSettings({
    this.selectedKey,
    this.isVisible = true,
  });
}
