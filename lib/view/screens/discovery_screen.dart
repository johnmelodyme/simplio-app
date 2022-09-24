import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/search_bar_placeholder.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer,
            Theme.of(context).colorScheme.background,
          ],
        ),
      ),
      child: NavigationTabBar(
        tabs: [
          NavigationBarTabItem(
            label: context.locale.discovery_tab_games,
            searchBar: SearchBarPlaceholder(
              onTap: () {
                GoRouter.of(context).pushNamed(
                  AuthenticatedRouter.gamesSearch,
                );
              },
              label: context.locale.inventory_screen_search_and_add_coins,
            ),
            iconData: Icons.sports_esports_outlined,
            iconColor: Theme.of(context).colorScheme.onBackground,
            topSlivers: [],
            bottomSlivers: [],
          ),
          NavigationBarTabItem(
            label: context.locale.discovery_tab_coins,
            searchBar: SearchBarPlaceholder(
              label: context.locale.inventory_screen_search_and_add_coins,
            ),
            iconData: Icons.pie_chart_outline,
            iconColor: Theme.of(context).colorScheme.surface,
            topSlivers: [],
            bottomSlivers: [],
          ),
          NavigationBarTabItem(
            label: context.locale.discovery_tab_nft,
            searchBar: SearchBarPlaceholder(
              label: context.locale.inventory_screen_search_and_add_coins,
            ),
            iconData: Icons.pie_chart_outline,
            iconColor: Theme.of(context).colorScheme.onSurface,
            topSlivers: [],
            bottomSlivers: [],
          )
        ],
      ),
    );
  }
}
