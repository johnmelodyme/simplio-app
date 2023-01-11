import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/logic/bloc/asset_swap_form/asset_swap_form_bloc.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_swap_form_screen.dart';

class AssetSwapFormRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'asset-swap-form';
  static const path = 'swap';

  const AssetSwapFormRoute({
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
        builder: (state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AssetSwapFormBloc(
                swapRepository: RepositoryProvider.of<SwapRepository>(context),
              )..add(state.extra as RoutesLoaded),
            ),
            // TODO - ExpansionList shold we statefull instead of using cubit with storing single index value.
            BlocProvider(
              create: (context) => ExpansionListCubit.builder(),
            ),
          ],
          child: const AssetSwapFormScreen(),
        ),
      ),
    );
  }
}
