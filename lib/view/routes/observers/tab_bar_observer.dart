import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/logic/cubit/navigators/navigators_cubit.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';

class NavigatorsObserver extends NavigatorObserver {
  final BuildContext context;

  NavigatorsObserver.of(this.context);

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
      _setTabBarVisibility(args.navigators);
    } else {
      _hideTabBar();
    }
  }

  void _setTabBarVisibility(NavigatorsRouteSettings? navigatorsSettings) {
    if (navigatorsSettings == null) return;

    context.read<NavigatorsCubit>().setVisibility(
          appBarVisible: navigatorsSettings.isAppBarVisible,
          tabBarVisible: navigatorsSettings.isTabBarVisible,
          activeItem: navigatorsSettings.selectedKey,
        );
  }

  void _hideTabBar() {
    context.read<NavigatorsCubit>().setVisibility();
  }
}
