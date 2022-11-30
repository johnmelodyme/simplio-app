import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/app_bar_mask.dart';
import 'package:simplio_app/view/widgets/avatar_app_bar.dart';

class AvatarAppBarBlured extends StatelessWidget {
  const AvatarAppBarBlured({super.key});

  @override
  Widget build(BuildContext context) {
    final topGap = MediaQuery.of(context).viewPadding.top;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: topGap + Constants.appBarHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SioColors.softBlack.withOpacity(0.8),
                      SioColors.appBarTop.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: Dimensions.padding16,
                height: topGap + Constants.appBarHeight + Dimensions.padding16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SioColors.softBlack.withOpacity(0.8),
                      SioColors.appBarTop.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: Dimensions.padding16,
                height: topGap + Constants.appBarHeight + Dimensions.padding16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SioColors.softBlack.withOpacity(0.8),
                      SioColors.appBarTop.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: topGap + Constants.appBarHeight,
          left: 0,
          right: 0,
          child: const AppBarMask(
            height: Dimensions.padding16,
            offset: Dimensions.padding16,
          ),
        ),
        Positioned(
          left: Dimensions.padding16,
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
    );
  }
}
