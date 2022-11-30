import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/app_bar_mask.dart';
import 'package:simplio_app/view/widgets/avatar_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class DappsScreen extends StatelessWidget {
  const DappsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.coinsBottomTabBarHeight;
    final topGap = MediaQuery.of(context).viewPadding.top;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SioScaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverGap(MediaQuery.of(context).viewPadding.top +
                      Constants.appBarHeight),
                  const SliverGap(Dimensions.padding20),
                  SliverToBoxAdapter(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${context.locale.find_dapps_screen_discover}\n',
                            style: SioTextStyles.h1.apply(
                              color: SioColors.whiteBlue,
                            ),
                          ),
                          TextSpan(
                            text: '${context.locale.find_dapps_screen_dapps} ',
                            style: SioTextStyles.h1
                                .apply(color: SioColors.mentolGreen),
                          ),
                          TextSpan(
                            text: context.locale.find_dapps_screen_world,
                            style: SioTextStyles.h1
                                .apply(color: SioColors.whiteBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverGap(Dimensions.padding5),
                  SliverToBoxAdapter(
                    child: Text(
                      context.locale.find_dapps_screen_description,
                      textAlign: TextAlign.center,
                      style: SioTextStyles.s1.apply(
                        color: SioColors.secondary7,
                      ),
                    ),
                  ),
                  const SliverGap(Dimensions.padding20),
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/find_dapps_coming_soon.png',
                          alignment: Alignment.centerRight,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 1,
                          right: 23,
                          child: SizedBox(
                            width: 180,
                            child: Image.asset(
                              'assets/images/simpliona_dapps.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverGap(bottomGap)
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: SizedBox(height: topGap + Constants.appBarHeight),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBarMask(
                height: topGap + Constants.appBarHeight + Dimensions.padding20,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: AvatarAppBar(
                title: 'Nick name',
                userLevel: 1,
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    AuthenticatedRouter.configuration,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
