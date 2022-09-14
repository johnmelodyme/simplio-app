import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

const int maxUserLevel = 4;

class UserLevelBar extends StatelessWidget {
  const UserLevelBar({
    super.key,
    this.userLevel = 0,
  }) : assert(userLevel <= 4);

  final int userLevel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.locale.common_user_level,
          style: SioTextStyles.bodyDetail
              .apply(color: Theme.of(context).colorScheme.secondaryContainer),
        ),
        const Gap(Dimensions.padding5),
        Row(
          children: Iterable<int>.generate(maxUserLevel).map((int level) {
            final icon = Icon(
              Icons.star,
              size: 15,
              color: userLevel <= level
                  ? Theme.of(context).colorScheme.onTertiaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
            );
            if (userLevel <= level) {
              return icon;
            } else {
              return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: icon);
            }
          }).toList(),
        )
      ],
    );
  }
}
