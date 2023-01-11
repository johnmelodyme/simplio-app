import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/account_setup_success_screen.dart';

class AccountSetupSuccessRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'account-setup-success';
  static const path = 'account-setup/success';

  const AccountSetupSuccessRoute({
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
        builder: (state) => const AccountSetupSuccessScreen(),
      ),
    );
  }
}
