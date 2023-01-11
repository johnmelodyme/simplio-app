import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/dapps_screen.dart';

class FindDappsRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'find-dapps';
  static const path = 'find-dapps';

  const FindDappsRoute({
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
        builder: (state) => const DappsScreen(),
      ),
    );
  }
}
