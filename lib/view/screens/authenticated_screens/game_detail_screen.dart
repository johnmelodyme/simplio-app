import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/asset_swap_form/asset_swap_form_bloc.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/view/routers/authenticated_routes/gameplay_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/coin_details_menu.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart' as app_bar;
import 'package:simplio_app/view/widgets/game_detail_balance.dart';
import 'package:simplio_app/view/widgets/game_detail_info.dart';
import 'package:simplio_app/view/widgets/game_detail_socials.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/sio_expandable_text.dart';
import 'package:simplio_app/view/widgets/slidable_game_images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_swap_form_route.dart';

class GameDetailScreen extends StatelessWidget {
  const GameDetailScreen({
    super.key,
    required this.gameId,
  });

  final String gameId;

  Future<void> openLink(String uriLink) async {
    try {
      if (await canLaunchUrl(Uri.parse(uriLink))) {
        await launchUrl(
          Uri.parse(uriLink),
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Couldn\'t open the link');
      }
    } catch (e) {
      debugPrint('Couldn\'t open the link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GamesBloc cubit = context.read<GamesBloc>();
    final topGap = MediaQuery.of(context).viewPadding.top;
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.coinsBottomTabBarHeight;

    final Game game = cubit.getGameById(int.parse(gameId));
    final String assetId = game.assetEmbedded.assetId.toString();
    final String networkId = game.assetEmbedded.networkId.toString();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackGradient4(
                child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                BlocBuilder<GamesBloc, GamesState>(
                  bloc: cubit..add(LoadGameEvent(gameId: gameId)),
                  builder: (context, state) {
                    if (state is GamesLoadingState) {
                      return const SliverFillRemaining(
                        child: Center(child: ListLoading()),
                      );
                    } else if (state is GameDetailLoadedState) {
                      return SliverToBoxAdapter(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(MediaQuery.of(context).viewPadding.top +
                              Constants.appBarHeight),
                          Gaps.gap16,
                          SlidableGameImages(
                            images: state.gameDetail.preview
                                .map((p) => p.low)
                                .toList(),
                          ),
                          Gaps.gap20,
                          Padding(
                            padding: Paddings.horizontal16,
                            child: GameDetailInfo(
                              gameDetail: state.gameDetail,
                            ),
                          ),
                          Gaps.gap20,
                          Padding(
                            padding: Paddings.horizontal16,
                            child: GameDetailBalance(
                              gameDetail: state.gameDetail,
                            ),
                          ),
                          Gaps.gap20,
                          Padding(
                            padding: Paddings.horizontal16,
                            child: SioExpandableText(state.gameDetail.caption),
                          ),
                          Gaps.gap20,
                          Padding(
                            padding: Paddings.horizontal16,
                            child: GameDetailSocials(
                              references: state.gameDetail.references,
                              onReferenceClicked: (reference) {
                                openLink(reference.url);
                              },
                            ),
                          ),
                          Gaps.gap20,

                          /*
                          TODO..complete NFTs after MVP
                          Padding(
                            padding: Paddings.horizontal16,
                            child: Text(
                              context.locale.game_detail_screen_my_game_nfts,
                              style: SioTextStyles.h5.apply(
                                color: SioColors.whiteBlue,
                              ),
                            ),
                          ),
                          */
                          Gap(bottomGap)
                        ],
                      ));
                    } else {
                      return const SliverToBoxAdapter(
                        child: Text('Unknown State'),
                      );
                    }
                  },
                ),
              ],
            )),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SizedBox(height: topGap + Constants.appBarHeight),
              ),
            ),
          ),
          app_bar.ColorizedAppBar(
            title: context.locale.game_detail_screen_game_title,
            actionType: app_bar.ActionType.close,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CoinDetailsMenu(
              allowedActions: const [ActionType.play, ActionType.swap],
              onActionCallback: (actionType) async {
                switch (actionType) {
                  case ActionType.play:
                    GoRouter.of(context).pushNamed(
                      GameplayRoute.name,
                      extra: game,
                    );
                    break;
                  case ActionType.buyCoin:
                    // TODO - add buy coin when ready.
                    break;
                  // TODO - check if a user has a wallet for this network. If not, hide the swap button.
                  case ActionType.swap:
                    return GoRouter.of(context).pushNamed(
                      AssetSwapFormRoute.name,
                      extra: RoutesLoaded(
                        assetId: int.parse(assetId),
                        networkId: int.parse(networkId),
                      ),
                    );
                  default:
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
