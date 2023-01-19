import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_detail_screen.dart';

class AssetDetailRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'asset-detail';
  static const path = 'asset/:assetId/:networkId';

  const AssetDetailRoute({
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
        builder: (state) => AssetDetailScreen(
          assetId: state.params['assetId'],
          networkId: state.params['networkId'],
        ),
      ),
    );
  }
}