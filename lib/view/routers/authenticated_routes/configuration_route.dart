import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/configuration_screen.dart';

class ConfigurationRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'configuration';
  static const path = 'configuration';

  const ConfigurationRoute({
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
        builder: (state) => const ConfigurationScreen(
          key: ValueKey('configuration'),
        ),
        withTransition: false,
      ),
    );
  }
}
