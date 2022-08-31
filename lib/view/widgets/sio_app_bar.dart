import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class SioAppBar extends StatelessWidget {
  const SioAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.height = Constants.appBarHeight,
  });

  final String title;
  final String? subtitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SioAppBarDelegate(
          title: title,
          subtitle: subtitle,
          height: height + MediaQuery.of(context).viewPadding.top,
        ));
  }
}

class SioAppBarDelegate extends SliverPersistentHeaderDelegate {
  SioAppBarDelegate({
    required this.title,
    this.subtitle,
    required this.height,
  });
  final String title;
  final String? subtitle;
  final double height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              bottom: PaddingSize.padding20,
              left: PaddingSize.padding16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(55, 255, 198, 0.35),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: Offset(1, 1),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(55, 255, 198, 0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/icon/profile_avatar_pic.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const Gap(PaddingSize.padding10),
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
                      if (subtitle != null) ...[
                        const Gap(3),
                        Text(
                          subtitle!,
                          style: SioTextStyles.bodyLabel.apply(
                              color: Theme.of(context).colorScheme.onTertiary),
                        )
                      ],
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

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
