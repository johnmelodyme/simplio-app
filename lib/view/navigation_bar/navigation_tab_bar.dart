import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/navigation_bar/navigation_bar_tab_item.dart';
import 'package:simplio_app/view/navigation_bar/navigation_tab_chip.dart';
import 'package:simplio_app/view/themes/constants.dart';

class NavigationTabBar extends StatefulWidget {
  NavigationTabBar({
    Key? key,
    required this.tabs,
    this.currentTab = 0,
    this.addTopGap = true,
  })  : assert(tabs.isNotEmpty),
        assert(currentTab < tabs.length),
        super(key: key);

  final List<NavigationBarTabItem> tabs;
  final int currentTab;

  final bool addTopGap;

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  int currentTab = 0;

  // There is the following issue which made me to implement resetting the scroll position to 0.
  // https://github.com/flutter/flutter/issues/53040
  final scrollController = ScrollController();

  @override
  void initState() {
    currentTab = widget.currentTab;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(40);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onTabTap(tabIndex) {
    if (currentTab == tabIndex) return;
    setState(() => currentTab = tabIndex);
    scrollController.jumpTo(40);
  }

  @override
  Widget build(BuildContext context) {
    final fixedHeight = 45 + MediaQuery.of(context).viewPadding.top;
    const topGap = PaddingSize.padding32;
    final bottomGap = MediaQuery.of(context).viewPadding.bottom + 56;

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: PaddingSize.padding20),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverGap(fixedHeight + 24),
                if (widget.addTopGap) const SliverGap(topGap),
                ...widget.tabs[currentTab].pageSlivers,
                SliverGap(bottomGap),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: PaddingSize.padding20),
          child: Container(
            height: 45,
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
                          isSelected: currentTab == widget.tabs.indexOf(tab),
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
        ),
      ],
    );
  }
}
