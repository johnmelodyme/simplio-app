import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/discovery_screen.dart';

class DiscoveryRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'discovery';
  static const path = 'discovery';

  const DiscoveryRoute({
    required super.navigator,
    super.routes,
  });

  @override
  GoRoute get route {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: navigator,
      routes: routes,
      pageBuilder: pageBuilder(
        withTransition: false,
        builder: (state) {
          final e = state.extra;

          return DiscoveryScreen(
            key: UniqueKey(),
            tab: e is DiscoveryTab ? e : DiscoveryTab.games,
          );
        },
      ),
    );
  }
}
