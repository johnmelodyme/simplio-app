import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/screens/authenticated_screens/my_games_screen.dart';

class GamesRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'games';
  static const path = 'games';

  const GamesRoute({
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
        builder: (state) => const MyGamesScreen(),
      ),
    );
  }
}
