import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar_container.dart';
import 'package:simplio_app/view/widgets/coin_details_menu_button.dart';

typedef CoinDetailsMenuCallback = void Function(ActionType actioType);

class CoinDetailsMenu extends StatelessWidget {
  const CoinDetailsMenu({
    super.key,
    required this.onActionCallback,
  });

  final CoinDetailsMenuCallback onActionCallback;

  @override
  Widget build(BuildContext context) {
    final List<CoinDetailMenuItem> coinMenuItems = [
      CoinDetailMenuItem(
        actionType: ActionType.buy,
        label: context.locale.coin_detail_screen_menu_buy,
        icon: Icons.shopping_basket,
      ),
      CoinDetailMenuItem(
        actionType: ActionType.exchange,
        label: context.locale.coin_detail_screen_menu_exchange,
        icon: Icons.swap_horiz,
      ),
      CoinDetailMenuItem(
        actionType: ActionType.receive,
        label: context.locale.coin_detail_screen_menu_receive,
        icon: Icons.vertical_align_bottom,
      ),
      CoinDetailMenuItem(
        actionType: ActionType.send,
        label: context.locale.coin_detail_screen_menu_send,
        icon: Icons.vertical_align_top,
      ),
      CoinDetailMenuItem(
        actionType: ActionType.earn,
        label: context.locale.coin_detail_screen_menu_earn,
        icon: Icons.north_east,
      ),
    ];

    return BottomTabBarContainer(
      height: Constants.coinsBottomTabBarHeight,
      borderRadius: RadiusSize.radius20,
      child: ListView.separated(
        padding: Paddings.vertical16,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return Row(
            children: [
              if (index == 0) const Gap(Dimensions.padding16),
              CoinDetailsMenuButton(
                  key: ValueKey(coinMenuItems[index].actionType),
                  label: coinMenuItems[index].label,
                  icon: coinMenuItems[index].icon,
                  onPressed: () {
                    onActionCallback.call(coinMenuItems[index].actionType);
                  }),
              if (index == coinMenuItems.length - 1)
                const Gap(Dimensions.padding16),
            ],
          );
        },
        separatorBuilder: (_, index) {
          return const Gap(
            Dimensions.padding5,
          );
        },
        itemCount: coinMenuItems.length,
      ),
    );
  }
}

enum ActionType { buy, exchange, receive, send, earn }

class CoinDetailMenuItem {
  final ActionType actionType;
  final String label;
  final IconData icon;

  CoinDetailMenuItem({
    required this.actionType,
    required this.label,
    required this.icon,
  });
}
