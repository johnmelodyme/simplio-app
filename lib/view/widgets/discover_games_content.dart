import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
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
  late GamesCubit cubit;

  void addLoadEvent(int offset) {
    cubit.loadGames(offset);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: BlocProvider(
        create: (context) {
          cubit = GamesCubit.builder(
            marketplaceRepository:
                RepositoryProvider.of<MarketplaceRepository>(context),
          )..pagingController.addPageRequestListener(addLoadEvent);
          return cubit;
        },
        child: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            return PagedSliverList.separated(
              pagingController: cubit.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Game>(
                itemBuilder: (context, item, index) {
                  return GameItem(
                    game: item,
                    gameActions: const [
                      GameAction.play,
                      GameAction.buyCoin,
                    ],
                    onActionPressed: (GameAction gameAction) {},
                    onTap: () {},
                  );
                },
                firstPageProgressIndicatorBuilder: (_) =>
                    Column(children: const [
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
                    cubit.reloadGames();
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
                      cubit.loadGames(cubit.pagingController.nextPageKey!);
                    },
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Gaps.gap10,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    cubit.dispose();
    cubit.pagingController.removePageRequestListener(addLoadEvent);
    super.dispose();
  }
}
