import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar_container.dart';
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
                          key: e.key,
                          flex: spacerRatio,
                          child: _TabBarItem(
                            isActive: activeItem == e.key,
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
