import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/empty_list_placeholder.dart';
import 'package:simplio_app/view/widgets/game_item.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/tap_to_retry_loader.dart';

class MyGamesContent extends StatefulWidget {
  const MyGamesContent({
    super.key,
    required this.onCoinAdd,
  });

  final Function(int, int) onCoinAdd;

  @override
  State<MyGamesContent> createState() => _MyGamesContentState();
}

class _MyGamesContentState extends State<MyGamesContent> {
  GamesCubit? cubit;

  void _buyCoin(BuildContext context, String assetId, String networkId) {
    context.read<AssetBuyFormCubit>().clear();
    GoRouter.of(context).pushNamed(AuthenticatedRouter.assetBuy, params: {
      'assetId': assetId,
      'networkId': networkId,
    });
  }

  @override
  Widget build(BuildContext context) {
    cubit ??= GamesCubit.builder(
      userRepository: RepositoryProvider.of<UserRepository>(context),
      marketplaceRepository:
          RepositoryProvider.of<MarketplaceRepository>(context),
    );
    cubit?.loadMyGames();
    final accountWalletCubit = context.read<AccountWalletCubit>();
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: BlocProvider(
        create: (context) {
          return cubit!;
        },
        child: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            if (state is GamesLoadingState) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: ListLoading(),
                ),
              );
            } else if (state is GamesErrorState) {
              return SliverToBoxAdapter(
                child: Padding(
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
                      cubit?.loadMyGames();
                    },
                  ),
                ),
              );
            } else if (state is MyGamesLoadedState) {
              if (state.games.isEmpty) {
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      EmptyListPlaceholder(
                        label: context.locale.my_games_screen_empty_list_label,
                        child: Image.asset(
                          'assets/images/empty_transactions_placeholder.png',
                        ),
                      ),
                      Gaps.gap20,
                      SizedBox(
                        width: 234,
                        child: HighlightedElevatedButton(
                          label:
                              context.locale.my_games_screen_discover_new_games,
                          onPressed: () {
                            GoRouter.of(context)
                                .goNamed(AuthenticatedRouter.discovery);
                          },
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final game = state.games[index];
                      return Column(
                        children: [
                          GameItem(
                            key: ValueKey(game.gameId),
                            game: game,
                            gameActions: const [
                              GameAction.play,
                              GameAction.buyCoin,
                            ],
                            onActionPressed: (GameAction gameAction) {
                              if (gameAction == GameAction.play) {
                                GoRouter.of(context).pushNamed(
                                  AuthenticatedRouter.gameplay,
                                  extra: game,
                                );
                              } else if (gameAction == GameAction.buyCoin) {
                                final String assetId =
                                    game.assetEmbedded.assetId.toString();
                                final String networkId =
                                    game.assetEmbedded.networkId.toString();

                                if (accountWalletCubit.hasNetworkWalledAdded(
                                  assetId: int.parse(assetId),
                                  networkId: int.parse(networkId),
                                )) {
                                  _buyCoin(context, assetId, networkId);
                                } else {
                                  widget.onCoinAdd.call(
                                    int.parse(assetId),
                                    int.parse(networkId),
                                  );
                                }
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
                          if (index < state.games.length) Gaps.gap10,
                        ],
                      );
                    },
                    childCount: state.games.length,
                  ),
                );
              }
            } else {
              return const SliverToBoxAdapter(child: Text('Unknow state'));
            }
          },
        ),
      ),
    );
  }
}
