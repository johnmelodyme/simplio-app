import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
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
    final fixedHeight = topGap + Constants.appBarHeight;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          StatefulBuilder(builder: (
            context,
            state,
          ) {
            return Positioned.fill(
              child: RefreshIndicator(
                edgeOffset: fixedHeight,
                color: SioColors.softBlack,
                backgroundColor: SioColors.whiteBlue,
                onRefresh: () async =>
                    widget.tabs[currentTab].onRefresh?.call(),
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
                              child: Container(
                                height: Constants.navigationTabBarHeight,
                                decoration: BoxDecoration(
                                  color: SioColors.backGradient4Start,
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
                                              isSelected: currentTab ==
                                                  widget.tabs.indexOf(tab),
                                              onTap: () {
                                                if (currentTab ==
                                                    widget.tabs.indexOf(tab)) {
                                                  return;
                                                }
                                                state(() => currentTab =
                                                    widget.tabs.indexOf(tab));
                                              },
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
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
            );
          }),
        ],
      ),
    );
  }
}
