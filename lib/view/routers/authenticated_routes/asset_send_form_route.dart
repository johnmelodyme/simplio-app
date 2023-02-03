import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:simplio_app/logic/bloc/asset_send_form/asset_send_form_bloc.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/screens/authenticated_screens/asset_send_form_screen.dart';

class AssetSendFormRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'asset-send-form';
  static const path = '/send';

  const AssetSendFormRoute({
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
              create: (context) => AssetSendFormBloc(
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
              )..add(state.extra as PriceLoaded),
            ),
            BlocProvider(
              create: (context) => ExpansionListCubit.builder(),
            ),
          ],
          child: const AssetSendFormScreen(),
        ),
      ),
    );
  }
}
