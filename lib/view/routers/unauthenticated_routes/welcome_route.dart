import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/unauthenticated_screens/welcome_screen.dart';

class WelcomeRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'welcome';
  static const path = '/welcome';

  const WelcomeRoute({
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
        builder: (state) => const WelcomeScreen(),
      ),
    );
  }
}
