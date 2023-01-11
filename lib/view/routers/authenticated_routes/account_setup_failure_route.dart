import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';

// TODO - implement this route with the correct screen.
class AccountSetupFailureRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'account-setup-failure';
  static const path = 'account-setup/failure';

  const AccountSetupFailureRoute({
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
        builder: (state) => const Scaffold(
          body: Center(
            child: Text('Reload account'),
          ),
        ),
      ),
    );
  }
}
