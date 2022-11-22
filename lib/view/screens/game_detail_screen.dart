import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/app_bar_mask.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/coin_details_menu.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart' as app_bar;
import 'package:simplio_app/view/widgets/game_detail_balance.dart';
import 'package:simplio_app/view/widgets/game_detail_info.dart';
import 'package:simplio_app/view/widgets/game_detail_socials.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/screen_with_dialog.dart';
import 'package:simplio_app/view/widgets/sio_expandable_text.dart';
import 'package:simplio_app/view/widgets/slidable_game_images.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailScreen extends ScreenWithDialog {
  GameDetailScreen({
    super.key,
    required this.gameId,
  }) : super(
          panelController: PanelController(),
        );

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
  Widget innerBuild(BuildContext context) {
    final AccountWalletCubit accountWalletCubit =
        context.read<AccountWalletCubit>();
    final GamesBloc cubit = context.read<GamesBloc>();
    final topGap = MediaQuery.of(context).viewPadding.top;
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.coinsBottomTabBarHeight;

    final Game game = cubit.getGameById(int.parse(gameId));
    final String assetId = game.assetEmbedded.assetId.toString();
    final String networkId = game.assetEmbedded.networkId.toString();

    return Stack(
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
                          images: state.gameDetail.preview,
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
                        child: Text('Unknow State'));
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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBarMask(
            height: topGap + Constants.appBarHeight + Dimensions.padding20,
          ),
        ),
        app_bar.ColorizedAppBar(
          firstPart: context.locale.game_detail_screen_game_title,
          secondPart: context.locale.game_detail_screen_detail_title,
          actionType: app_bar.ActionType.close,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CoinDetailsMenu(
            allowedActions: const [
              ActionType.play,
              ActionType.buyCoin,
              ActionType.exchange
            ],
            onActionCallback: (actionType) async {
              switch (actionType) {
                case ActionType.play:
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.gameplay,
                    extra: game,
                  );
                  break;
                case ActionType.buyCoin:
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
                  break;
                case ActionType.exchange:
                  if (accountWalletCubit.hasNetworkWalledAdded(
                    assetId: int.parse(assetId),
                    networkId: int.parse(networkId),
                  )) {
                    _exchangeCoin(context, assetId, networkId);
                  } else {
                    context.read<DialogCubit>().showDialog(
                      (proceed) async {
                        if (proceed) {
                          _exchangeCoin(context, assetId, networkId);
                        }
                      },
                      DialogType.createCoin,
                    );
                  }

                  break;
                default:
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  void _buyCoin(BuildContext context, String assetId, String networkId) {
    context.read<AssetBuyFormCubit>().clear();
    GoRouter.of(context).pushNamed(AuthenticatedRouter.assetBuy, params: {
      'assetId': assetId,
      'networkId': networkId,
    });
  }

  void _exchangeCoin(BuildContext context, String assetId, String networkId) {
    context.read<AssetExchangeFormCubit>().clear();
    GoRouter.of(context).pushNamed(
      AuthenticatedRouter.assetExchange,
      params: {
        'assetId': assetId,
        'networkId': networkId,
      },
    );
  }
}
