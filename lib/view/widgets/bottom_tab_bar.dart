import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar_container.dart';

enum TabItemType {
  button,
  spacer,
}

class TabBarItem {
  final Key? key;
  final String value;
  final TabItemType tabBarItemType;
  final VoidCallback? onTap;
  final IconData? icon;
  final IconData? activeIcon;
  final Color selectedColor;
  final String? label;

  TabBarItem({
    this.key,
    this.tabBarItemType = TabItemType.button,
    required this.selectedColor,
    required this.value,
    this.onTap,
    this.icon,
    this.activeIcon,
    this.label,
  });
}

class BottomTabBar extends StatelessWidget {
  final List<TabBarItem> items;
  final FloatingActionButton? floatingActionButton;
  final double height;
  final double floatingActionButtonOffset;
  final double elevation;
  final double borderRadius;
  final int spacerRatio;
  final bool showLabel;
  final String currentPath;

  const BottomTabBar({
    super.key,
    required this.items,
    required this.currentPath,
    this.floatingActionButton,
    this.height = Constants.bottomTabBarHeight,
    this.floatingActionButtonOffset = 20,
    this.elevation = 20.0,
    this.borderRadius = RadiusSize.radius20,
    this.spacerRatio = 2,
    this.showLabel = true,
  })  : assert(items.length <= 5),
        assert(floatingActionButtonOffset > 0);

  @override
  Widget build(BuildContext context) {
    return BottomTabBarContainer(
      height: height,
      borderRadius: borderRadius,
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
                          child: const SizedBox.shrink(),
                        );
                      }

                      return Expanded(
                          key: e.key ?? ObjectKey(e.value),
                          flex: spacerRatio,
                          child: _TabBarItem(
                            isActive: _isItemActive(
                              currentPath,
                              segment: e.value,
                            ),
                            tabBarItem: e,
                            selectedColor: e.selectedColor,
                            unselectedColor: SioColors.whiteBlue,
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
    );
  }

  bool _isItemActive(
    String path, {
    required String segment,
  }) {
    return path.contains(segment);
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
        onTap: tabBarItem.onTap,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tabBarItem.icon,
              size: 30,
              color: isActive ? selectedColor : unselectedColor,
            ),
            Text(
              tabBarItem.label ?? '',
              style: SioTextStyles.bodyDetail.apply(
                color: isActive ? selectedColor : unselectedColor,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
