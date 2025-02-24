import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/back_gradient1.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:sio_glyphs/sio_icons.dart';

class GameDetailBalance extends StatelessWidget {
  const GameDetailBalance({
    required this.gameDetail,
  }) : super(key: const Key('game-detail-balance'));

  final GameDetail gameDetail;

  @override
  Widget build(BuildContext context) {
    final assetDetail = Assets.getAssetDetail(gameDetail.assetEmbedded.assetId);

    return ClipRRect(
      borderRadius: BorderRadii.radius20,
      child: BackGradient1(
        child: Padding(
          padding: Paddings.all16,
          child: Row(
            children: [
              Icon(
                SioIcons.sports_esports,
                color: SioColors.games,
              ),
              Gaps.gap5,
              Text(
                context.locale.game_detail_screen_game_coin_balance,
                style: SioTextStyles.bodyS.copyWith(
                  color: SioColors.secondary7,
                  height: 1,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /*
                  TODO.. appear this value onace backend will support it
                  Text(
                    '68 GCOIN',
                    style: SioTextStyles.bodyPrimary.copyWith(
                      color: SioColors.whiteBlue,
                    ),
                  ),
                  */
                  CurrencyText(
                    BigDecimal.fromDouble(
                      gameDetail.assetEmbedded.price,
                    ),
                    currency: gameDetail.assetEmbedded.currency,
                    style: SioTextStyles.bodyPrimary.copyWith(
                      color: SioColors.whiteBlue,
                    ),
                  ),
                ],
              ),
              Gaps.gap10,
              AvatarWithShadow(
                size: 40,
                child: assetDetail.style.icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
