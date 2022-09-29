import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/app_bar_mask.dart';
import 'package:simplio_app/view/widgets/avatar_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/navigation_tab_chip.dart';

class NavigationBarTabItem {
  NavigationBarTabItem({
    required this.label,
    this.searchBar,
    this.searchController,
    required this.bottomSlivers,
    this.topSlivers,
    this.iconData,
    this.iconColor,
    this.onRefresh,
  });

  final String label;
  final Widget? searchBar;
  final TextEditingController? searchController;
  final List<Widget>? topSlivers;
  final List<Widget> bottomSlivers;
  final IconData? iconData;
  final Color? iconColor;
  final Future<void> Function()? onRefresh;
}

class NavigationTabBar extends StatefulWidget {
  NavigationTabBar({
    Key? key,
    required this.tabs,
    this.currentTab = 0,
  })  : assert(tabs.isNotEmpty),
        assert(currentTab < tabs.length),
        super(key: key);

  final List<NavigationBarTabItem> tabs;
  final int currentTab;

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  int currentTab = 0;

  final scrollController = ScrollController();

  void onTabTap(tabIndex) {
    if (currentTab == tabIndex) return;
    setState(() => currentTab = tabIndex);
  }

  @override
  void initState() {
    currentTab = widget.currentTab;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.bottomTabBarHeight;

    final topGap = MediaQuery.of(context).viewPadding.top;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverGap(MediaQuery.of(context).viewPadding.top +
                  Constants.appBarHeight),
              if (widget.tabs[currentTab].topSlivers?.isNotEmpty == true)
                ...widget.tabs[currentTab].topSlivers!,
              SliverPadding(
                padding: Paddings.horizontal16,
                sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: FixedHeightItemDelegate(
                        fixedHeight: Constants.navigationTabBarHeight,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(RadiusSize.radius64),
                          ),
                          child: Container(
                            height: Constants.navigationTabBarHeight,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ...widget.tabs
                                    .map(
                                      (tab) => Expanded(
                                        child: NavigationTabChip(
                                          label: tab.label,
                                          iconData: tab.iconData,
                                          iconColor: tab.iconColor,
                                          isSelected: currentTab ==
                                              widget.tabs.indexOf(tab),
                                          onTap: () {
                                            onTabTap(widget.tabs.indexOf(tab));
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ))),
              ),
              if (widget.tabs[currentTab].searchBar != null) ...[
                const SliverGap(Dimensions.padding20),
                SliverPadding(
                  padding: Paddings.horizontal16,
                  sliver: SliverPersistentHeader(
                    floating: true,
                    delegate: FixedHeightItemDelegate(
                        fixedHeight: Constants.searchBarHeight,
                        child: widget.tabs[currentTab].searchBar!),
                  ),
                )
              ],
              ...widget.tabs[currentTab].bottomSlivers,
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
    );
  }
}
