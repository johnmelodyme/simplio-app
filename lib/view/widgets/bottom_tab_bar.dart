import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
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
    this.height = Constants.bottomTabBarHeight,
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

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height + bottomPadding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ],
            ),
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
                                    selectedColor: e.selectedColor,
                                    unselectedColor: theme
                                        .bottomNavigationBarTheme
                                        .unselectedItemColor!));
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
        ),
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  final bool isActive;
  final TabBarItem tabBarItem;
  final Color selectedColor;
  final Color unselectedColor;

  const _TabBarItem({
    required this.isActive,
    required this.tabBarItem,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
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
