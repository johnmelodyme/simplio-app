import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar_container.dart';
import 'package:simplio_app/view/widgets/button/bottom_panel_button.dart';

class ScrollableBottomPanel extends StatelessWidget {
  final List<BottomPanelButton> children;

  const ScrollableBottomPanel({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return BottomTabBarContainer(
      height: Constants.coinsBottomTabBarHeight,
      borderRadius: RadiusSize.radius20,
      child: Padding(
        padding: Paddings.vertical8,
        child: ListView.separated(
          padding: Paddings.horizontal8,
          scrollDirection: Axis.horizontal,
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (_, __) => const Gap(
            Dimensions.padding8,
          ),
        ),
      ),
    );
  }
}
