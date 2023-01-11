import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/configuration_security_screen.dart';

class ConfigurationSecurityRoute extends ApplicationRoute
    with PageBuilderMixin {
  static const name = 'configuration-security';
  static const path = 'security';

  const ConfigurationSecurityRoute({
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
        builder: (state) => const ConfigurationSecurityScreen(
          key: ValueKey('configuration-security'),
        ),
        withTransition: false,
      ),
    );
  }
}
