import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/discover_games_content.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/search_bar_placeholder.dart';
import 'package:simplio_app/view/widgets/slidable_banner.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationTabBar(
      tabs: [
        NavigationBarTabItem(
          label: context.locale.discovery_tab_games,
          searchBar: SearchBarPlaceholder(
            onTap: () {
              GoRouter.of(context).pushNamed(
                AuthenticatedRouter.gamesSearch,
              );
            },
            label: context.locale.discovery_screen_search_and_add_games,
          ),
          iconData: Icons.sports_esports_outlined,
          iconColor: SioColors.games,
          topSlivers: [
            const SliverGap(Dimensions.padding16),
            const SlidableBanner(),
            const SliverGap(Dimensions.padding20),
          ],
          bottomSlivers: [
            const SliverGap(Dimensions.padding20),
            const DiscoverGamesContent(),
          ],
        ),
        NavigationBarTabItem(
          label: context.locale.discovery_tab_coins,
          searchBar: SearchBarPlaceholder(
            label: context.locale.discovery_screen_search_and_add_coins,
          ),
          iconData: Icons.pie_chart_outline,
          iconColor: SioColors.coins,
          topSlivers: [
            const SliverGap(Dimensions.padding16),
            const SlidableBanner(),
            const SliverGap(Dimensions.padding20),
          ],
          bottomSlivers: [],
        ),
        NavigationBarTabItem(
          label: context.locale.discovery_tab_nft,
          searchBar: SearchBarPlaceholder(
            label: context.locale.discovery_screen_search_nft,
          ),
          iconData: Icons.pie_chart_outline,
          iconColor: SioColors.nft,
          topSlivers: [
            const SliverGap(Dimensions.padding16),
            const SlidableBanner(),
            const SliverGap(Dimensions.padding20),
          ],
          bottomSlivers: [],
        )
      ],
    );
  }
}
