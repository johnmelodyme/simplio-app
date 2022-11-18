import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/games/game_bloc_event.dart';
import 'package:simplio_app/logic/cubit/games/games_bloc.dart';
import 'package:simplio_app/logic/cubit/games/games_search_bloc.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/game_item.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/search.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class GamesSearchScreen extends StatefulWidget {
  const GamesSearchScreen({super.key});

  @override
  State<GamesSearchScreen> createState() => _GamesSearchScreenState();
}

class _GamesSearchScreenState extends State<GamesSearchScreen>
    with PopupDialogMixin {
  late TextEditingController searchController = TextEditingController();
  late GamesSearchBloc bloc;
  late bool addedPageRequestLister;

  @override
  void initState() {
    bloc = GamesSearchBloc(
      userRepository: RepositoryProvider.of<UserRepository>(context),
      marketplaceRepository:
          RepositoryProvider.of<MarketplaceRepository>(context),
    );
    addedPageRequestLister = false;
    searchController.addListener(() => {
          _searchGames(bloc, searchController.text),
        });

    super.initState();
  }

  void _searchGames(GamesSearchBloc cubit, String criteria) {
    cubit.add(SearchGamesEvent(criteria));
  }

  void _addLoadEvent(GamesSearchBloc cubit, int offset) {
    cubit.add(LoadGamesEvent(page: offset));
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
        child: BlocProvider(
          create: (context) => bloc,
          child: BlocConsumer<GamesSearchBloc, GamesState>(
            listener: (context, state) {
              if (state is GamesLoadedState && !addedPageRequestLister) {
                addedPageRequestLister = true;
                bloc.pagingController.addPageRequestListener(
                  (offset) => _addLoadEvent(bloc, offset),
                );
              }

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
                  bloc.pagingController.itemList?.isEmpty == true) {
                return Column(
                  children: const [
                    Center(
                      child: Padding(
                        padding: Paddings.top32,
                        child: ListLoading(),
                      ),
                    ),
                  ],
                );
              } else {
                return PagedListView.separated(
                  padding: Paddings.top32,
                  physics: const BouncingScrollPhysics(),
                  pagingController: bloc.pagingController,
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
                              context.read<GamesSearchBloc>().add(
                                    AddGameToLibraryEvent(
                                        gameId: game.gameId, reload: true),
                                  );
                            } else if (gameAction == GameAction.remove) {
                              bloc.add(
                                RemoveGameFromLibraryEvent(
                                    gameId: game.gameId, reload: true),
                              );
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
                    firstPageProgressIndicatorBuilder: (_) => Column(
                      children: const [
                        Center(
                          child: Padding(
                            padding: Paddings.bottom32,
                            child: ListLoading(),
                          ),
                        ),
                      ],
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
                        bloc.add(const ReloadGamesEvent());
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
                          bloc.add(LoadGamesEvent(
                              page: bloc.pagingController.nextPageKey!));
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
