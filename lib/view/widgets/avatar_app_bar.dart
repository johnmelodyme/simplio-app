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
    this.onTap,
  });

  final String title;
  final int userLevel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final topGap = MediaQuery.of(context).viewPadding.top;

    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: topGap + Dimensions.padding16,
              bottom: Dimensions.padding20,
              left: Dimensions.padding16,
            ),
            child: SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AvatarWithShadow(
                      child: Image.asset(
                    'assets/icon/profile_avatar_pic.png',
                    width: 40,
                    height: 40,
                  )),
                  Gaps.gap10,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
