import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/user_level_bar.dart';

class AvatarAppBar extends StatelessWidget {
  const AvatarAppBar({
    super.key,
    required this.title,
    required this.userLevel,
  });

  final String title;
  final int userLevel;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              bottom: Dimensions.padding20,
              left: Dimensions.padding16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarWithShadov(
                    child: Image.asset(
                  'assets/icon/profile_avatar_pic.png',
                  width: 40,
                  height: 40,
                )),
                const Gap(Dimensions.padding10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: SioTextStyles.h4.apply(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const Gap(3),
                      UserLevelBar(
                        userLevel:
                            userLevel, //TODO replace with real user level
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(AuthenticatedRouter.qrCodeScanner);
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.qr_code,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        )),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.notifications_none,
                        color: Theme.of(context).colorScheme.surfaceTint,
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
