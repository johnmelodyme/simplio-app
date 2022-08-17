import 'package:flutter/material.dart';
import 'package:simplio_app/view/widgets/tab_bar_item.dart';

class BottomTabBar extends StatelessWidget {
  final List<TabBarItem> items;
  final FloatingActionButton? floatingActionButton;
  final double height;
  final double floatingActionButtonOffset;
  final double elevation;
  final double borderRadius;
  final int spacerRatio;
  final bool showLabel;
  final Key activeItem;

  const BottomTabBar({
    super.key,
    required this.items,
    required this.activeItem,
    this.floatingActionButton,
    this.height = 56,
    this.floatingActionButtonOffset = 20,
    this.elevation = 20.0,
    this.borderRadius = 20.0,
    this.spacerRatio = 2,
    this.showLabel = true,
  })  : assert(items.length <= 5),
        assert(floatingActionButtonOffset > 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: height + bottomPadding,
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: height,
              child: Builder(
                builder: (context) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: items.map((e) {
                        if (e.tabBarItemType == TabItemType.spacer) {
                          return Expanded(
                            key: UniqueKey(),
                            flex: 1,
                            child: Container(),
                          );
                        }

                        return Expanded(
                            key: e.key,
                            flex: spacerRatio,
                            child: _TabBarItem(
                              isActive: activeItem == e.key,
                              tabBarItem: e,
                            ));
                      }).toList());
                },
              ),
            ),
            if (floatingActionButton != null)
              Positioned(
                top: 0,
                child: floatingActionButton!,
              ),
          ],
        ),
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  final bool isActive;
  final TabBarItem tabBarItem;

  const _TabBarItem({
    required this.isActive,
    required this.tabBarItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color? selectedColor =
        theme.bottomNavigationBarTheme.selectedItemColor;
    final Color? unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          tabBarItem.onTap?.call(context, tabBarItem.key!);
        },
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                tabBarItem.icon,
                color: isActive ? selectedColor : unselectedColor,
              ),
            ),
            Text(
              tabBarItem.label ?? '',
              style: TextStyle(
                fontSize: 12.0,
                color: isActive ? selectedColor : unselectedColor,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
