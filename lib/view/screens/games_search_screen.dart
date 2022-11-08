import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/game_item.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class GamesSearchScreen extends StatelessWidget with PopupDialogMixin {
  GamesSearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  void _searchGames(GamesCubit cubit, String criteria) {
    cubit.search(criteria);
  }

  void _addLoadEvent(GamesCubit cubit, int offset) {
    cubit.loadGames(offset);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = GamesCubit.builder(
      userRepository: RepositoryProvider.of<UserRepository>(context),
      marketplaceRepository:
          RepositoryProvider.of<MarketplaceRepository>(context),
    );

    searchController.addListener(() => {
          _searchGames(cubit, searchController.text),
        });

    return Search(
        firstPart: context.locale.games_search_screen_search_and_add,
        secondPart: context.locale.games_search_screen_games,
        searchHint: context.locale.games_search_screen_search,
        searchController: searchController,
        autoFocusSearch: true,
        appBarStyle: AppBarStyle.multiColored,
        child: BlocProvider(
          create: (context) => cubit
            ..pagingController.addPageRequestListener(
              (offset) => _addLoadEvent(cubit, offset),
            ),
          child: BlocConsumer<GamesCubit, GamesState>(
            listener: (context, state) {
              if (state is GameDetailIsAddedState && state.wasUpdated) {
                final isAdded = state.isAdded!;
                showPopup(
                  context,
                  message: isAdded
                      ? context.locale.game_detail_screen_game_added
                      : context.locale.game_detail_screen_game_removed,
                  icon: Image.asset(
                    'assets/icon/simpliona_icon.png',
                    height: 50,
                    width: 50,
                  ),
                );
              }
            },
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
                    itemBuilder: (context, game, index) {
                      return Padding(
                        padding: Paddings.horizontal16,
                        child: GameItem(
                          game: game,
                          gameActions: [
                            GameAction.play,
                            game.isAdded
                                ? GameAction.remove
                                : GameAction.addToMyGames,
                          ],
                          onActionPressed: (GameAction gameAction) {
                            if (gameAction == GameAction.play) {
                              GoRouter.of(context).pushNamed(
                                AuthenticatedRouter.gameplay,
                                extra: game,
                              );
                            } else if (gameAction == GameAction.addToMyGames) {
                              context
                                  .read<GamesCubit>()
                                  .addGameToLibrary(game.gameId, reload: true);
                            } else if (gameAction == GameAction.remove) {
                              cubit.removeGameFromLibrary(game.gameId,
                                  reload: true);
                            } else if (gameAction == GameAction.play) {
                              //TODO.. handle play game CTA
                            }
                          },
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                              AuthenticatedRouter.gameDetail,
                              params: {
                                'gameId': game.gameId.toString(),
                              },
                            );
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
                          cubit.loadGames(context
                              .read<GamesCubit>()
                              .pagingController
                              .nextPageKey!);
                        },
                      ),
                    ),
                    noMoreItemsIndicatorBuilder: (_) => Gaps.gap20,
                    noItemsFoundIndicatorBuilder: (_) =>
                        const SizedBox.shrink(),
                  ),
                  separatorBuilder: (context, index) => Gaps.gap10,
                );
              }
            },
          ),
        ));
  }
}
