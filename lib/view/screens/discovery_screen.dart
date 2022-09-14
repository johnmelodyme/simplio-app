import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/avatar_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: FixedHeightItemDelegate(
            fixedHeight:
                Constants.appBarHeight + MediaQuery.of(context).viewPadding.top,
            child: const AvatarAppBar(
              title: 'Nickname',
              userLevel: 1,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 600,
            padding: const EdgeInsets.all(
              Dimensions.padding20,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(RadiusSize.radius20),
                    topRight: Radius.circular(RadiusSize.radius20)),
                color: Theme.of(context).colorScheme.background),
            child: Column(
              children: [
                Material(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: CommonTheme.borderRadius,
                    side: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context)
                          .goNamed(AuthenticatedRouter.inventory);
                    },
                    child: SizedBox(
                      height: 200,
                      child: Padding(
                        padding: CommonTheme.paddingAll,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.sports_esports_outlined,
                                size: 32.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
