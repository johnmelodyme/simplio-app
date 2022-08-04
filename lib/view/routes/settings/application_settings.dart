import 'package:flutter/material.dart';

class ApplicationSettings extends RouteSettings {
  final TapBarRouteSettings? tapBar;

  @override
  ApplicationArguments get arguments => ApplicationArguments(
        tapBar: tapBar,
      );

  const ApplicationSettings({
    this.tapBar,
  });
}

class ApplicationArguments {
  final TapBarRouteSettings? tapBar;

  ApplicationArguments({
    this.tapBar,
  });
}

class TapBarRouteSettings {
  final Key selectedKey;
  final bool isVisible;

  TapBarRouteSettings({
    required this.selectedKey,
    this.isVisible = true,
  });
}
