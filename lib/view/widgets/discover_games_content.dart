import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/view/routers/authenticated_routes/game_detail_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/gameplay_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/game_item.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class DiscoverGamesContent extends StatefulWidget {
  const DiscoverGamesContent({super.key});

  @override
  State<DiscoverGamesContent> createState() => _DiscoverGamesContentState();
}

class _DiscoverGamesContentState extends State<DiscoverGamesContent> {
  late GamesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<GamesBloc>();
    bloc.pagingController.addPageRequestListener(_addLoadEvent);
  }

  void _addLoadEvent(int offset) {
    bloc.add(LoadGamesEvent(page: offset));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: BlocBuilder<GamesBloc, GamesState>(
        builder: (context, state) {
          return PagedSliverList.separated(
            pagingController: context.read<GamesBloc>().pagingController,
            builderDelegate: PagedChildBuilderDelegate<Game>(
              itemBuilder: (context, game, index) {
                return GameItem(
                  game: game,
                  currency: 'USD',
                  gameActions: game.isPromoted
                      ? const [
                          GameAction.play,
                          GameAction.buyCoin,
                        ]
                      : [],
                  onActionPressed: (GameAction gameAction) {
                    if (gameAction == GameAction.play) {
                      GoRouter.of(context).pushNamed(
                        GameplayRoute.name,
                        extra: game,
                      );
                    }

                    if (gameAction == GameAction.buyCoin) {
                      // TODO - Navigator to buy screen when buy is implemented.
                    }
                  },
                  onTap: game.isPromoted
                      ? () {
                          if (!game.isPromoted) return;
                          GoRouter.of(context).pushNamed(
                            GameDetailRoute.name,
                            params: {
                              'gameId': game.gameId.toString(),
                            },
                          );
                        }
                      : null,
                );
              },
              firstPageProgressIndicatorBuilder: (_) => Column(children: const [
                Center(child: ListLoading()),
                Spacer(),
              ]),
              newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                padding: Paddings.bottom32,
                child: ListLoading(),
              )),
              firstPageErrorIndicatorBuilder: (_) => TapToRetryLoader(
                isLoading: state is GamesLoadingState,
                loadingIndicator: const Center(
                  child: Padding(
                    padding: Paddings.bottom32,
                    child: ListLoading(),
                  ),
                ),
                onTap: () {
                  bloc.add(const ReloadGamesEvent());
                },
              ),
              noMoreItemsIndicatorBuilder: (_) => Gaps.gap20,
              noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageErrorIndicatorBuilder: (_) => Padding(
                padding: Paddings.bottom32,
                child: TapToRetryLoader(
                  isLoading: state is GamesLoadingState,
                  loadingIndicator: const Center(
                    child: Padding(
                      padding: Paddings.bottom32,
                      child: ListLoading(),
                    ),
                  ),
                  onTap: () {
                    bloc.add(LoadGamesEvent(
                        page: bloc.pagingController.nextPageKey!));
                  },
                ),
              ),
            ),
            separatorBuilder: (context, index) => Gaps.gap10,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.pagingController.removePageRequestListener(_addLoadEvent);
    super.dispose();
  }
}
