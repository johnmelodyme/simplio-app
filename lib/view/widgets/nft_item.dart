import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/promoted_red_strip.dart';
import 'package:simplio_app/view/widgets/small_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

class NftItem extends StatelessWidget {
  const NftItem({
    super.key,
    required this.nft,
    this.onTap,
    required this.nftAction,
    required this.onActionPressed,
  });

  final SearchNftItem nft;
  final VoidCallback? onTap;
  final List<NftAction> nftAction;
  final Function(NftAction) onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.gameItemHeight,
      clipBehavior: Clip.hardEdge,
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
        borderRadius: nft.isPromoted
            ? const BorderRadius.only(
                topLeft: Radius.circular(RadiusSize.radius30),
                topRight: Radius.circular(RadiusSize.radius10),
                bottomRight: Radius.circular(RadiusSize.radius30),
                bottomLeft: Radius.circular(RadiusSize.radius30),
              )
            : BorderRadii.radius30,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: Paddings.all20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nft.name,
                            overflow: TextOverflow.ellipsis,
                            style: SioTextStyles.h4.apply(
                              color: SioColors.whiteBlue,
                            ),
                          ),
                          Text(
                            nft.game,
                            overflow: TextOverflow.ellipsis,
                            style: SioTextStyles.bodyL.apply(
                              color: SioColors.secondary7,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Icon(
                                  SioIcons.nft,
                                  color: SioColors.nft,
                                ),
                              ),
                              Gaps.gap5,
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: context
                                          .locale.common_item_nft_price_label,
                                      style: SioTextStyles.bodyDetail.apply(
                                        color: SioColors.secondary7,
                                      ),
                                    ),
                                    TextSpan(
                                      text: nft.price
                                          .getThousandValueWithCurrency(
                                        currency: nft.currency,
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
                        ],
                      ),
                      SmallButton(
                        label: context.locale.nft_item_action_types(
                          NftAction.buyNft.name,
                        ),
                        type: SmallButtonType.solid,
                        labelColor: SioColors.whiteBlue,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: Constants.gameItemHeight,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: SioColors.backGradient2,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(RadiusSize.radius30),
                    bottomLeft: Radius.circular(RadiusSize.radius30),
                  ),
                ),
                child: Image.network(
                  nft.preview.high,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  errorBuilder: (_, __, ___) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          if (nft.isPromoted)
            Align(
              alignment: Alignment.topRight,
              child: PromotedRedStrip(
                label: context.locale.common_top_uc,
              ),
            ),
        ],
      ),
    );
  }
}

enum NftAction { buyNft }
