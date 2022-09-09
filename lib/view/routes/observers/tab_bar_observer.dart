import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/logic/cubit/tab_bar/tab_bar_cubit.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';

class TabBarObserver extends NavigatorObserver {
  final BuildContext context;

  TabBarObserver.of(this.context);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleArguments(route.settings.arguments);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _handleArguments(newRoute?.settings.arguments);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleArguments(previousRoute?.settings.arguments);
  }

  void _handleArguments(Object? args) {
    if (args == null) return;

    if (args is ApplicationSettings) {
      _setTabBarVisibility(args.tabBar);
    } else {
      _hideTabBar();
    }
  }

  void _setTabBarVisibility(TabBarRouteSettings? tabBarSettings) {
    if (tabBarSettings == null) return;

    context.read<TabBarCubit>().setVisibility(
          isVisible: tabBarSettings.isVisible,
          activeItem: tabBarSettings.selectedKey,
        );
  }

  void _hideTabBar() {
    context.read<TabBarCubit>().setVisibility();
  }
}
