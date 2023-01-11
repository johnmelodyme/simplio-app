import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/routers/authenticated_routes/discovery_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/find_dapps_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/games_route.dart';
import 'package:simplio_app/view/routers/authenticated_routes/inventory_route.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar.dart';
import 'package:sio_glyphs/sio_icons.dart';

class TabBarShell extends StatelessWidget {
  final String path;
  final Widget child;

  const TabBarShell({
    super.key,
    this.path = '',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomTabBar(
                // activeItem: state.selectedItem,
                currentPath: path,
                items: [
                  TabBarItem(
                      value: context.namedLocation(DiscoveryRoute.name),
                      selectedColor: SioColors.mentolGreen,
                      icon: SioIcons.gridview,
                      label: context
                          .locale.application_screen_discovery_tabbar_label,
                      onTap: () {
                        GoRouter.of(context).goNamed(
                          DiscoveryRoute.name,
                        );
                      }),
                  TabBarItem(
                      value: context.namedLocation(GamesRoute.name),
                      selectedColor: SioColors.games,
                      icon: SioIcons.sports_esports,
                      label:
                          context.locale.application_screen_games_tabbar_label,
                      onTap: () {
                        GoRouter.of(context).goNamed(
                          GamesRoute.name,
                        );
                      }),
                  TabBarItem(
                      value: context.namedLocation(InventoryRoute.name),
                      selectedColor: SioColors.coins,
                      icon: SioIcons.inventory,
                      label: context
                          .locale.application_screen_inventory_tabbar_label,
                      onTap: () {
                        GoRouter.of(context).goNamed(
                          InventoryRoute.name,
                        );
                      }),
                  TabBarItem(
                      value: context.namedLocation(FindDappsRoute.name),
                      selectedColor: SioColors.vividBlue,
                      icon: SioIcons.world,
                      label: context
                          .locale.application_screen_find_dapps_tabbar_label,
                      onTap: () {
                        GoRouter.of(context).goNamed(
                          FindDappsRoute.name,
                        );
                      }),
                ],
                height: 70.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
