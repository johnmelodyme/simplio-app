import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/http/services/games_service.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/small_bordered_button.dart';
import 'package:simplio_app/view/widgets/small_solid_button.dart';

class GameItem extends StatelessWidget {
  const GameItem({
    super.key,
    required this.game,
    this.onTap,
  });

  final Game game;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiuses.radius30,
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                      //TODO.. reach out of colors => should be refactored by using ColorProvider
                      Color(0xFF092F45),
                      Color(0xFF0B3B57),
                      Color(0xFF0B3B57),
                    ],
                    stops: [0, 0.33, 1],
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
                      //TODO.. reach out of colors => should be refactored by using ColorProvider
                      const Color(0xFF092F45),
                      const Color(0xFF0B3B57),
                      const Color(0xFF0B3B57).withOpacity(0.73),
                      const Color(0xFF0B3B57).withOpacity(0.0),
                      const Color(0xFF0B3B57).withOpacity(0.0)
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
                  highlightColor: const Color(0xFF0B3B57).withOpacity(0.73),
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
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                              context.locale
                                  .common_games_categories(game.category),
                              style: SioTextStyles.bodyL.apply(
                                color: Theme.of(context).colorScheme.shadow,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.sports_esports_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                const Gap(Dimensions.padding5),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: context
                                            .locale.game_item_coin_price_label,
                                        style: SioTextStyles.bodyDetail.apply(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                        ),
                                      ),
                                      TextSpan(
                                        text: game.assetEmbedded.price
                                            .getThousandValueWithCurrency(
                                          currency: game.assetEmbedded.currency,
                                          locale: Intl.getCurrentLocale(),
                                        ),
                                        style: SioTextStyles.bodyDetail.apply(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(Dimensions.padding8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallSolidButton(
                                  label: 'Play',
                                  onPressed: () {
                                    //TODO.. open game
                                  },
                                ),
                                const Gap(Dimensions.padding5),
                                SmallBorderedButton(
                                  label: 'Add to My Games',
                                  onPressed: () {
                                    //TODO.. add to my games
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
