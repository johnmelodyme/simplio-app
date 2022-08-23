import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class SioAppBar extends StatelessWidget {
  const SioAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.height = Constants.appBarHeight,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: MyHeaderDelegate(
          title: title,
          subtitle: subtitle,
          height: height + MediaQuery.of(context).viewPadding.top,
        ));
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  MyHeaderDelegate({
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
                      Text(title,
                          style: SioTextStyles.h4.apply(
                              color: Theme.of(context).colorScheme.onPrimary)),
                      if (subtitle != null) ...{
                        const Gap(3),
                        Text(subtitle!,
                            style: SioTextStyles.bodyLabel.apply(
                                color:
                                    Theme.of(context).colorScheme.onTertiary))
                      },
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(
                        'assets/icon/svg/icon_qr_code.svg',
                        color: Theme.of(context).colorScheme.inverseSurface,
                        height: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(
                        'assets/icon/svg/icon_belt.svg',
                        color: Theme.of(context).colorScheme.surfaceTint,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(
                          'assets/icon/svg/icon_menu_vertical.svg',
                          color: Theme.of(context).colorScheme.surfaceTint,
                          width: 16,
                          height: 16),
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
