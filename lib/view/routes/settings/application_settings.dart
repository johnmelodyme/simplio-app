import 'package:flutter/material.dart';

class ApplicationSettings extends RouteSettings {
  final NavigatorsRouteSettings? navigators;

  @override
  ApplicationArguments get arguments => ApplicationArguments(
        navigators: navigators,
      );

  const ApplicationSettings({
    this.navigators,
  });

  const ApplicationSettings.hiddenNavigators({
    this.navigators = const NavigatorsRouteSettings(
        isAppBarVisible: false, isTabBarVisible: false),
  });
}

class ApplicationArguments {
  final NavigatorsRouteSettings? navigators;

  ApplicationArguments({
    this.navigators,
  });
}

class NavigatorsRouteSettings {
  final Key? selectedKey;
  final bool isAppBarVisible;
  final bool isTabBarVisible;

  const NavigatorsRouteSettings({
    this.selectedKey,
    this.isAppBarVisible = true,
    this.isTabBarVisible = true,
  });
}
