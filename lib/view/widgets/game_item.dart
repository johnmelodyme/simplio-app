import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/http/services/games_service.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/favourite_start.dart';
import 'package:simplio_app/view/widgets/promoted_red_strip.dart';
import 'package:simplio_app/view/widgets/small_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

class GameItem extends StatelessWidget {
  const GameItem({
    super.key,
    required this.game,
    this.onTap,
    required this.gameActions,
    required this.onActionPressed,
    this.isFavourite,
  });

  final Game game;
  final Function? onTap;
  final List<GameAction> gameActions;
  final Function(GameAction) onActionPressed;
  final bool? isFavourite;

  Color getTextColorByActionType(BuildContext context, GameAction gameAction) {
    switch (gameAction) {
      case GameAction.play:
        return SioColors.whiteBlue;
      case GameAction.buyCoin:
        return SioColors.softBlack;
      case GameAction.addToMyGames:
        return SioColors.secondary7;
      case GameAction.remove:
        return SioColors.secondary6;
    }
  }

  SmallButtonType getButtonStyleByActionType(
      BuildContext context, GameAction gameAction) {
    switch (gameAction) {
      case GameAction.play:
        return SmallButtonType.solid;
      case GameAction.buyCoin:
        return SmallButtonType.highlighted;
      case GameAction.addToMyGames:
      case GameAction.remove:
        return SmallButtonType.bordered;
    }
  }

  Color? getBorderColorByActionType(
      BuildContext context, GameAction gameAction) {
    if (gameAction == GameAction.addToMyGames) {
      return SioColors.secondary7;
    } else if (gameAction == GameAction.remove) {
      return SioColors.secondary6;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: game.isPromoted
          ? const BorderRadius.only(
              topLeft: Radius.circular(RadiusSize.radius30),
              topRight: Radius.circular(RadiusSize.radius10),
              bottomRight: Radius.circular(RadiusSize.radius30),
              bottomLeft: Radius.circular(RadiusSize.radius30),
            )
          : BorderRadii.radius30,
      child: SizedBox(
        height: Constants.gameItemHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                      SioColors.searchItemStartGradient,
                      SioColors.searchItemEndGradient,
                      SioColors.searchItemEndGradient,
                    ],
                    stops: const [0, 0.33, 1],
                  ),
                ),
              ),
            ),
            Image.network(
              game.preview,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) {
                return const SizedBox.shrink();
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      SioColors.searchItemStartGradient,
                      SioColors.searchItemEndGradient,
                      SioColors.searchItemEndGradient.withOpacity(0.73),
                      SioColors.searchItemEndGradient.withOpacity(0.0),
                      SioColors.searchItemEndGradient.withOpacity(0.0)
                    ],
                    stops: const [0, 0.37, 0.45, 0.66, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor:
                      SioColors.searchItemEndGradient.withOpacity(0.73),
                  onTap: () => onTap?.call(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Dimensions.padding17,
                      right: Dimensions.padding20,
                      bottom: Dimensions.padding20,
                      left: Dimensions.padding20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.name,
                              style: SioTextStyles.h4.apply(
                                color: SioColors.whiteBlue,
                              ),
                            ),
                            Text(
                              context.locale
                                  .common_games_categories(game.category),
                              style: SioTextStyles.bodyL.apply(
                                color: SioColors.secondary7,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Icon(
                                    SioIcons.sports_esports,
                                    color: SioColors.games,
                                  ),
                                ),
                                Gaps.gap5,
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: context.locale
                                            .common_item_coin_price_label,
                                        style: SioTextStyles.bodyDetail.apply(
                                          color: SioColors.secondary7,
                                        ),
                                      ),
                                      TextSpan(
                                        text: game.assetEmbedded.price
                                            .getThousandValueWithCurrency(
                                          currency: game.assetEmbedded.currency,
                                          locale: Intl.getCurrentLocale(),
                                        ),
                                        style: SioTextStyles.bodyDetail
                                            .apply(color: SioColors.whiteBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gaps.gap8,
                            Wrap(
                              spacing: Dimensions.padding5,
                              runSpacing: Dimensions.padding5,
                              children: gameActions.map((gameAction) {
                                return SmallButton(
                                  label: context.locale
                                      .game_item_action_types(gameAction.name),
                                  onPressed: () {
                                    onActionPressed.call(gameAction);
                                  },
                                  type: getButtonStyleByActionType(
                                      context, gameAction),
                                  labelColor: getTextColorByActionType(
                                      context, gameAction),
                                  borderColor: getBorderColorByActionType(
                                      context, gameAction),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isFavourite != null)
              Align(
                alignment: Alignment.topRight,
                child: FavouriteStar(isFilled: isFavourite!),
              )
            else if (game.isPromoted)
              Align(
                alignment: Alignment.topRight,
                child: PromotedRedStrip(
                  label: context.locale.common_top_uc,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum GameAction { play, buyCoin, addToMyGames, remove }
