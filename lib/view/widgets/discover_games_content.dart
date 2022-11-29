import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
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

  void _buyCoin(BuildContext context, String assetId, String networkId) {
    context.read<AssetBuyFormCubit>().clear();
    GoRouter.of(context).pushNamed(AuthenticatedRouter.assetBuy, params: {
      'assetId': assetId,
      'networkId': networkId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountWalletCubit = context.read<AccountWalletCubit>();
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
                  gameActions: game.isPromoted
                      ? const [
                          GameAction.play,
                          GameAction.buyCoin,
                        ]
                      : [],
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
                        context.read<DialogCubit>().showDialog(
                          (proceed) async {
                            if (proceed) {
                              await accountWalletCubit
                                  .enableNetworkWallet(
                                assetId: int.parse(assetId),
                                networkId: int.parse(networkId),
                              )
                                  .then((_) {
                                _buyCoin(context, assetId, networkId);
                              });
                            }
                          },
                          DialogType.createCoin,
                        );
                      }
                    }
                  },
                  onTap: game.isPromoted
                      ? () {
                          if (!game.isPromoted) return;
                          GoRouter.of(context).pushNamed(
                            AuthenticatedRouter.gameDetail,
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
