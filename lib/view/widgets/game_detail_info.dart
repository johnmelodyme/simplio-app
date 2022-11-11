import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/marketplace_repository.dart';
import 'package:simplio_app/data/repositories/user_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/games/games_cubit.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/back_gradient2.dart';
import 'package:simplio_app/view/widgets/bordered_text_button.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:sio_glyphs/sio_icons.dart';

class GameDetailInfo extends StatelessWidget with PopupDialogMixin {
  const GameDetailInfo({
    required this.gameDetail,
  }) : super(key: const Key('game-detail-info'));

  final GameDetail gameDetail;

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = context.read<UserRepository>();
    final MarketplaceRepository marketplaceRepository =
        context.read<MarketplaceRepository>();

    final GamesCubit cubit = GamesCubit.builder(
        userRepository: userRepository,
        marketplaceRepository: marketplaceRepository);

    return ClipRRect(
      borderRadius: BorderRadii.radius20,
      child: BackGradient2(
        child: Padding(
          padding: Paddings.all16,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gameDetail.name,
                        style: SioTextStyles.h3.copyWith(
                          color: SioColors.whiteBlue,
                        ),
                      ),
                      Gaps.gap5,
                      Text(
                        context.locale
                            .common_games_categories(gameDetail.category),
                        style: SioTextStyles.bodyPrimary.copyWith(
                          color: SioColors.secondary7,
                        ),
                      ),
                    ],
                  ),
                  //ScoreChip(value: 855),  TODO.. appear this score when backend will support it
                ],
              ),
              Gaps.gap20,
              BlocConsumer<GamesCubit, GamesState>(
                bloc: cubit..checkIfIsAdded(gameDetail.gameId),
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
                  if (state is GamesLoadingState) {
                    return const Center(child: ListLoading());
                  } else if (state is GameDetailIsAddedState) {
                    if (state.isAdded == true) {
                      return BorderedTextButton(
                        onPressed: () {
                          cubit.removeGameFromLibrary(gameDetail.gameId);
                        },
                        label: context
                            .locale.game_detail_screen_remove_from_my_games,
                        icon: Icon(
                          SioIcons.cancel_outline,
                          color: SioColors.secondary6,
                        ),
                      );
                    } else if (state.isAdded == false) {
                      return HighlightedElevatedButton(
                        onPressed: () {
                          cubit.addGameToLibrary(gameDetail.gameId);
                        },
                        label:
                            context.locale.game_detail_screen_add_to_my_games,
                        icon: Icon(
                          SioIcons.plus_rounded,
                          color: SioColors.softBlack,
                        ),
                      );
                    } else {
                      return const SizedBox(
                        height: Constants.buttonHeight,
                      );
                    }
                  } else {
                    return const Text('Unknow State');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}