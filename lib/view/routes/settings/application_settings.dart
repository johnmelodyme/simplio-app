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
}

class ApplicationArguments {
  final TabBarRouteSettings? tabBar;

  ApplicationArguments({
    this.tabBar,
  });
}

class TabBarRouteSettings {
  final Key selectedKey;
  final bool isVisible;

  TabBarRouteSettings({
    required this.selectedKey,
    this.isVisible = true,
  });
}
