import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/game_item.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class GamesSearchScreen extends StatefulWidget {
  const GamesSearchScreen({super.key});

  @override
  State<GamesSearchScreen> createState() => _GamesSearchScreenState();
}

class _GamesSearchScreenState extends State<GamesSearchScreen> {
  late GamesCubit cubit;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    cubit = context.read<GamesCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.addListener(() => {
            _searchGames(searchController.text),
          });
      cubit.pagingController.addPageRequestListener(_loadGamesPage);
    });

    super.initState();
  }

  void _searchGames(String criteria) {
    cubit.search(criteria);
  }

  void _loadGamesPage(int pageKey) {
    cubit.loadGames(pageKey);
  }

  @override
  Widget build(BuildContext context) {
    return Search(
      firstPart: context.locale.games_search_screen_search_and_add,
      secondPart: context.locale.games_search_screen_games,
      searchHint: context.locale.games_search_screen_search,
      searchController: searchController,
      autoFocusSearch: true,
      appBarStyle: AppBarStyle.multiColored,
      child: BlocBuilder<GamesCubit, GamesState>(
        builder: (context, state) {
          if (state is GamesInitialState) {
            return const SizedBox.shrink();
          } else if (state is GamesLoadingState &&
              cubit.pagingController.itemList?.isEmpty == true) {
            return const Center(
              child: Padding(
                padding: Paddings.top32,
                child: ListLoading(),
              ),
            );
          } else {
            return PagedListView.separated(
              padding: Paddings.top32,
              physics: const BouncingScrollPhysics(),
              pagingController: cubit.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Game>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: Paddings.horizontal16,
                    child: GameItem(
                      game: item,
                      gameActions: const [
                        GameAction.play,
                        GameAction.addToMyGames,
                      ],
                      onActionPressed: (GameAction gameAction) {},
                      onTap: () {
                        //TODO.. open game detail
                      },
                    ),
                  );
                },
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: ListLoading(),
                ),
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
                noMoreItemsIndicatorBuilder: (_) => Gaps.gap20,
                noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
              ),
              separatorBuilder: (context, index) => Gaps.gap10,
            );
          }
        },
      ),
    );
  }
}
