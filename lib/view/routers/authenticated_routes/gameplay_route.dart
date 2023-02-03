import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/screens/authenticated_screens/gameplay_screen.dart';

class GameplayRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'gameplay';
  static const path = '/gameplay';

  const GameplayRoute({
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
        builder: (state) => GameplayScreen(
          game: state.extra as Game,
        ),
      ),
    );
  }
}
