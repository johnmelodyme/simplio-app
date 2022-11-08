import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar_container.dart';
import 'package:simplio_app/view/widgets/coin_details_menu_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

typedef CoinDetailsMenuCallback = void Function(ActionType actioType);

class CoinDetailsMenu extends StatelessWidget {
  const CoinDetailsMenu({
    super.key,
    required this.onActionCallback,
    required this.allowedActions,
  });

  final CoinDetailsMenuCallback onActionCallback;
  final List<ActionType> allowedActions;

  CoinDetailMenuItem getItemByActionType(
      BuildContext context, ActionType actionType) {
    switch (actionType) {
      case ActionType.play:
        return CoinDetailMenuItem(
          actionType: ActionType.play,
          label: context.locale.coin_menu_play,
          icon: SioIcons.play,
        );
      case ActionType.buy:
        return CoinDetailMenuItem(
          actionType: ActionType.buy,
          label: context.locale.coin_menu_buy,
          icon: SioIcons.basket,
        );
      case ActionType.buyCoin:
        return CoinDetailMenuItem(
          actionType: ActionType.buyCoin,
          label: context.locale.coin_menu_buy_coin,
          icon: SioIcons.basket,
        );
      case ActionType.exchange:
        return CoinDetailMenuItem(
          actionType: ActionType.exchange,
          label: context.locale.coin_menu_exchange,
          icon: SioIcons.swap,
        );
      case ActionType.receive:
        return CoinDetailMenuItem(
          actionType: ActionType.receive,
          label: context.locale.coin_menu_receive,
          icon: SioIcons.vertical_align_bottom,
        );
      case ActionType.send:
        return CoinDetailMenuItem(
          actionType: ActionType.send,
          label: context.locale.coin_menu_send,
          icon: SioIcons.vertical_align_top,
        );
      case ActionType.earn:
        return CoinDetailMenuItem(
          actionType: ActionType.earn,
          label: context.locale.coin_menu_earn,
          icon: SioIcons.north_east,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CoinDetailMenuItem> coinMenuItems = [
      if (allowedActions.contains(ActionType.play))
        CoinDetailMenuItem(
          actionType: ActionType.play,
          label: context.locale.coin_menu_play,
          icon: SioIcons.play,
        ),
      if (allowedActions.contains(ActionType.buyCoin))
        CoinDetailMenuItem(
          actionType: ActionType.buyCoin,
          label: context.locale.coin_menu_buy_coin,
          icon: SioIcons.basket,
        ),
      if (allowedActions.contains(ActionType.buy))
        CoinDetailMenuItem(
          actionType: ActionType.buy,
          label: context.locale.coin_menu_buy,
          icon: SioIcons.basket,
        ),
      if (allowedActions.contains(ActionType.exchange))
        CoinDetailMenuItem(
          actionType: ActionType.exchange,
          label: context.locale.coin_menu_exchange,
          icon: SioIcons.swap,
        ),
      if (allowedActions.contains(ActionType.receive))
        CoinDetailMenuItem(
          actionType: ActionType.receive,
          label: context.locale.coin_menu_receive,
          icon: SioIcons.vertical_align_bottom,
        ),
      if (allowedActions.contains(ActionType.send))
        CoinDetailMenuItem(
          actionType: ActionType.send,
          label: context.locale.coin_menu_send,
          icon: SioIcons.vertical_align_top,
        ),
      if (allowedActions.contains(ActionType.earn))
        CoinDetailMenuItem(
          actionType: ActionType.earn,
          label: context.locale.coin_menu_earn,
          icon: SioIcons.north_east,
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
              if (index == 0) Gaps.gap16,
              CoinDetailsMenuButton(
                  key: ValueKey(allowedActions[index]),
                  label:
                      getItemByActionType(context, allowedActions[index]).label,
                  icon:
                      getItemByActionType(context, allowedActions[index]).icon,
                  onPressed: () {
                    onActionCallback.call(allowedActions[index]);
                  }),
              if (index == coinMenuItems.length - 1) Gaps.gap16,
            ],
          );
        },
        separatorBuilder: (_, index) {
          return const Gap(
            Dimensions.padding5,
          );
        },
        itemCount: allowedActions.length,
      ),
    );
  }
}

enum ActionType { play, buy, buyCoin, exchange, receive, send, earn }

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
