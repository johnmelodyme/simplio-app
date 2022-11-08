import 'package:flutter/material.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/back_gradient1.dart';
import 'package:sio_glyphs/sio_icons.dart';

const minRefsPerRow = 5;

class GameDetailSocials extends StatelessWidget {
  const GameDetailSocials({
    required this.references,
    required this.onReferenceClicked,
  }) : super(key: const Key('game-detail-socials'));

  final List<Reference> references;
  final Function(Reference) onReferenceClicked;

  IconData getIconByReference(ReferenceType referenceType) {
    switch (referenceType) {
      case ReferenceType.web:
        return SioIcons.website_link;
      case ReferenceType.discord:
        return SioIcons.discord;
      case ReferenceType.twitter:
        return SioIcons.twitter;
      case ReferenceType.telegram:
        return SioIcons.telegram;
      case ReferenceType.instagram:
        return SioIcons.instagram;
      case ReferenceType.youtube:
        return SioIcons.youtube;
      case ReferenceType.medium:
        return SioIcons.medium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius20,
      child: BackGradient1(
        child: Padding(
          padding: Paddings.all20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.locale.game_detail_screen_community,
                style: SioTextStyles.h5.apply(
                  color: SioColors.games,
                ),
              ),
              Gaps.gap14,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...references
                      .map(
                        (reference) => Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    onReferenceClicked.call(reference),
                                icon: Icon(
                                  getIconByReference(reference.referenceType),
                                  color: SioColors.games,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  if (references.length < minRefsPerRow)
                    Spacer(
                      flex: minRefsPerRow - references.length,
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
