import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:simplio_app/logic/cubit/asset_swap_summary/asset_swap_summary_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_swap_summary_screen.dart';

class AssetSwapSummaryRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'asset-swap-summary';
  static const path = 'summary';

  const AssetSwapSummaryRoute({
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
          create: (context) => AssetSwapSummaryCubit(
            swapRepository: RepositoryProvider.of<SwapRepository>(context),
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          ),
          child: const AssetSwapSummaryScreen(),
        ),
      ),
    );
  }
}
