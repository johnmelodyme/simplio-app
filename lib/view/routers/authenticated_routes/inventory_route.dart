import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/inventory_screen.dart';

class InventoryRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'inventory';
  static const path = '/inventory';

  const InventoryRoute({
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
        builder: (state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CryptoAssetBloc.builder(
                marketplaceRepository:
                    RepositoryProvider.of<MarketplaceRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => ExpansionListCubit.builder(),
            ),
          ],
          child: Builder(builder: (context) {
            final e = state.extra;
            return InventoryScreen(
              key: UniqueKey(),
              tab: e is InventoryTab ? e : InventoryTab.coins,
            );
          }),
        ),
      ),
    );
  }
}
