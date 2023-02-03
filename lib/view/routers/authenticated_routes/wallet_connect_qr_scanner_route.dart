import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/screens/authenticated_screens/wallet_connect_qr_scanner_screen.dart';

class WalletConnectQrScannerRoute extends ApplicationRoute
    with PageBuilderMixin {
  static const name = 'wallet-connect-qr-scanner';
  static const path = '/wallet-connect/scan';

  const WalletConnectQrScannerRoute({
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
        builder: (_) => const WalletConnectQrScannerScreen(),
      ),
    );
  }
}
