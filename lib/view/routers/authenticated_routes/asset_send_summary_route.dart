import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:simplio_app/logic/cubit/asset_send_summary/asset_send_summary_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_send_summary_screen.dart';

class AssetSendSummaryRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'asset-send-summary';
  static const path = 'summary';

  const AssetSendSummaryRoute({
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
        builder: (state) => BlocProvider(
          create: (context) => AssetSendSummaryCubit(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          ),
          child: const AssetSendSummaryScreen(),
        ),
      ),
    );
  }
}
