import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/game_detail_screen.dart';

class GameDetailRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'game-detail';
  static const path = 'game/:gameId';

  const GameDetailRoute({
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
              create: (context) => GamesBloc.builder(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                marketplaceRepository:
                    RepositoryProvider.of<MarketplaceRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => DialogCubit.builder(),
            ),
          ],
          child: GameDetailScreen(
            key: const ValueKey(name),
            gameId: state.params['gameId']!,
          ),
        ),
      ),
    );
  }
}
