import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/navigation_bar/navigation_bar_tab_item.dart';
import 'package:simplio_app/view/navigation_bar/navigation_tab_chip.dart';
import 'package:simplio_app/view/navigation_bar/search_bar_delegate.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/appbar_search.dart';

class NavigationTabBar extends StatefulWidget {
  NavigationTabBar({
    Key? key,
    required this.tabs,
    this.addSearchBar = false,
    this.currentTab = 0,
    this.topGap = 0,
  })  : assert(tabs.isNotEmpty),
        assert(currentTab < tabs.length),
        super(key: key);

  final List<NavigationBarTabItem> tabs;
  final bool addSearchBar;
  final int currentTab;
  final double topGap;

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  int currentTab = 0;

  // There is the following issue which made me to implement resetting the scroll position to 0.
  // https://github.com/flutter/flutter/issues/53040
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

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverGap(widget.topGap),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: PaddingSize.padding10,
            left: PaddingSize.padding20,
            right: PaddingSize.padding20,
          ),
          sliver: SliverPersistentHeader(
              pinned: true,
              delegate: FixedHeightItemDelegate(
                  fixedHeight: Constants.navigationTabBarHeight,
                  child: Container(
                    height: Constants.navigationTabBarHeight,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(RadiusSize.radius64),
                      ),
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
                                  isSelected:
                                      currentTab == widget.tabs.indexOf(tab),
                                  onTap: () {
                                    onTabTap(widget.tabs.indexOf(tab));
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ))),
        ),
        if (widget.addSearchBar) ...{
          SliverPadding(
              padding: const EdgeInsets.only(
                left: PaddingSize.padding20,
                right: PaddingSize.padding20,
              ),
              sliver: SliverPersistentHeader(
                  floating: true,
                  delegate: ShrinkableSearchBarItemDelegate(
                    fixedHeight: Constants.navigationTabBarHeight +
                        PaddingSize.padding10,
                    child: AppBarSearch<String>(
                      delegate: SearchBarDelegate.of(context),
                      label: context.locale.searchAllAssetsInputLabel,
                    ),
                  ))),
        },
        ...widget.tabs[currentTab].pageSlivers,
        SliverGap(bottomGap)
      ],
    );
  }
}

class FixedHeightItemDelegate extends SliverPersistentHeaderDelegate {
  FixedHeightItemDelegate({required this.child, required this.fixedHeight});
  final Widget child;
  final double fixedHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => fixedHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class ShrinkableSearchBarItemDelegate extends SliverPersistentHeaderDelegate {
  ShrinkableSearchBarItemDelegate(
      {required this.child, required this.fixedHeight});
  final Widget child;
  final double fixedHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(children: [
              Flexible(child: SizedBox(height: fixedHeight)),
              child,
            ])));
  }

  @override
  double get maxExtent => fixedHeight + Constants.searchBarHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
