import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

const int maxUserLevel = 4;

class UserLevelBar extends StatelessWidget {
  const UserLevelBar({
    super.key,
    this.userLevel = 0,
  }) : assert(userLevel <= 4);

  final int userLevel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.locale.common_user_level,
            style: SioTextStyles.bodyDetail
                .copyWith(height: 1, color: SioColors.confirm),
          ),
          Gaps.gap5,
          Row(
            children: Iterable<int>.generate(maxUserLevel).map((int level) {
              final icon = Icon(
                Icons.star,
                size: 15,
                color: userLevel <= level
                    ? SioColors.backGradient3End
                    : SioColors.confirm,
              );
              if (userLevel <= level) {
                return icon;
              } else {
                return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: SioColors.mentolGreen.withOpacity(0.15),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    child: icon);
              }
            }).toList(),
          )
        ],
      ),
    );
  }
}
