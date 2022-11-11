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
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
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
                  SliverPadding(
                    padding: Paddings.horizontal16,
                    sliver: SliverPersistentHeader(
                      floating: true,
                      delegate: FixedHeightItemDelegate(
                        fixedHeight: Constants.assetItemHeight,
                        child: Image.asset(
                          'assets/images/empty_transactions_placeholder.png',
                        ),
                      ),
                    ),
                  ),
                  const SliverGap(Dimensions.padding40),
                  SliverPadding(
                    padding: Paddings.horizontal16,
                    sliver: SliverPersistentHeader(
                      floating: true,
                      delegate: FixedHeightItemDelegate(
                          fixedHeight: Constants.earningButtonHeight,
                          child: Text(context.locale.common_coming_soon,
                              textAlign: TextAlign.center,
                              style: SioTextStyles.h2.copyWith(
                                color: SioColors.white,
                              ))),
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
